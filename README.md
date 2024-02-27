# Process Suspender
A quick PowerShell utility which launches and immediately suspends a provided process for a specified amount of time.

Prompts for process name, amount of time in seconds to leave the process in a suspended state. Once the time elapses, the process will resume execution. Alternatively, the arguments can be supplied directly into the script using the -p (process) and -t (time in seconds) parameters. For example:

`.\suspend_process.ps1 -p calc.exe -t 5`

https://github.com/bobby-tablez/Process-Suspender/assets/908880/63508131-0c41-4882-874c-28a4921a928a

