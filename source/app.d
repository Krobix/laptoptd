import std.stdio;
import std.string;
import std.file;
import std.process;
import core.thread;

int main()
{
	while(true){
		auto acpiStatus = executeShell("acpi -a");
		string output = strip(acpiStatus.output);
		if(acpiStatus.status != 0) {
			writeln("ACPI error");
			return 1;
		}

		else {
			if(output == "Adapter 0: on-line") {
				if (!exists("/run/laptoptd_pluggedin_status")){
					executeShell("cpupower frequency-set -g schedutil > /var/log/laptoptd_cpupower.log");
					executeShell("touch /run/laptoptd_pluggedin_status");
					executeShell("rm /run/laptoptd_unplugged_status");
					writeln("Detected that laptop is now plugged in, changing to schedutil");
				}
			}
			
			else {
				if(!exists("/run/laptoptd_unplugged_status")){
					executeShell("cpupower frequency-set -g powersave > /var/log/laptoptd_cpupower.log");
					executeShell("touch /run/laptoptd_unplugged_status");
					executeShell("rm /run/laptoptd_pluggedin_status");
					writeln("Detected that laptop is no longer plugged in, changing to powersave");
				}
			}
		}

		Thread.sleep(dur!"minutes"(2));
	}
}
