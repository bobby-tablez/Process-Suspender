Add-Type -TypeDefinition @'
    using System;
    using System.Diagnostics;
    using System.Runtime.InteropServices;

    public static class ThreadUtilities {

        [DllImport("kernel32.dll")]
        public static extern IntPtr OpenThread(int dwDesiredAccess, bool bInheritHandle, uint dwThreadId);

        [DllImport("kernel32.dll")]
        public static extern uint SuspendThread(IntPtr hThread);

        [DllImport("kernel32.dll")]
        public static extern int ResumeThread(IntPtr hThread);

        [DllImport("kernel32.dll", SetLastError = true)]
        
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool CloseHandle(IntPtr hObject);

        const int THREAD_SUSPEND_RESUME = 0x0002;

        public static void SuspendProcess(int pid) {

            Process proc = Process.GetProcessById(pid);

            if (proc.ProcessName == string.Empty)
                return;

            foreach (ProcessThread pT in proc.Threads) {

                IntPtr pOpenThread = OpenThread(THREAD_SUSPEND_RESUME, false, (uint)pT.Id);

                if (pOpenThread == IntPtr.Zero)
                    continue;

                SuspendThread(pOpenThread);
                CloseHandle(pOpenThread);
            }
        }

        public static void ResumeProcess(int pid) {

            Process proc = Process.GetProcessById(pid);

            if (proc.ProcessName == string.Empty)
                return;

            foreach (ProcessThread pT in proc.Threads) {

                IntPtr pOpenThread = OpenThread(THREAD_SUSPEND_RESUME, false, (uint)pT.Id);

                if (pOpenThread == IntPtr.Zero)
                    continue;

                int suspendCount = 0;

                do{

                    suspendCount = ResumeThread(pOpenThread);

                } while (suspendCount > 0);

                CloseHandle(pOpenThread);
            }
        }
    }
'@

$susProcess = Read-Host "Name of process to suspend"
$susTime = Read-Host "Amount of time in seconds to suspend process"

$process = Start-Process $susProcess -PassThru

[ThreadUtilities]::SuspendProcess($process.Id)
Write-Host -F Yellow "Process started and suspended with pid:" $process.Id

Start-Sleep -Seconds $susTime

[ThreadUtilities]::ResumeProcess($process.Id)
Write-Host -F Green  "Process resumed"
