Last change: 2005-07-26 mkern


About TCPIP patcher
-------------------

Beginning with Service Pack 2 for Windows XP Microsoft limited the number of
TCP connections which can be concurrently in Half-Open state (SYN sent but not
yet ACKed or RSTed) to 10. If this limit is reached all further connection
attempts are queued and processed at a constant rate. The limit of 10 is
hardcoded in the Windows TCP stack (implemented in tcpip.sys) and cannot be
changed by users/administrators.

tcpip_patcher.sys is a device driver running in the kernel which provides an
interface for Administrators to read and change the limit form userland. It
does this by finding tcpip.sys in memory and heuristically determining the
address of the variable containing the limit. The value at this address can
then be read and written using IOCTLs.

Obviously there is some danger in using this approach since modifying unknown
parts of kernel memory can lead to catastrophic effects. The driver attempts
to limit this danger by doing extensive error checking before writing anything.

Even though the limit is present in some versions of Windows for 64 bit
systems this driver is currently 32 bit only. Users of 64 bit systems may want
to use the patch from http://www.lvllord.de/ which modifies tcpip.sys on disk
and works for 64 bit as well as for 32 bit machines.


Motivation
----------

Microsoft's declared reason for having the 10 connection limit is to slow down
the spreading of worms. Since there seem to be people (even outside Microsoft)
who earnestly think the appropriate response to having an OS full of security
holes is to cripple its TCP stack I'd like to explain why I wrote this driver.

Let us assume there is some merit in fighting malicious code which has made it
onto your system and that the connection limit is an appropriate way to do
this in the case of worms.

For this to work the malicious code must not be able to control the system to
such a degree that it can simply disable the protection. The code must run as
an unprivileged user who cannot modify the kernel. In the case of home users
this requirement is almost never met since they usually work on their machines
using Administrator accounts and any malicous code they contract can
immediately take over everything. Even if the code is initially limited in its
access rights there are plenty of local vulnerabilities to gain Adminstrator
access. For a dedicated attacker the connection limit is thus merely an
annoyance.

On the other hand it limits valid uses of the OS considerably. The performance
of all applications which need to make connections to hosts which may be
unreachable will decrease. Since applications cannot tell if their connection
attempts have been queued they don't even have a way to respond to the
situation by modifying their behaviour to still achieve satisfactory
performance.

One example of applications affected by the limit is P2P programs. The number
of firewalled nodes on most file sharing networks currently in use is well
over 50%. On some networks it is not known in advance which nodes are
firewalled and half of the application's connections will time out over a
period of 30+ seconds under normal operation. With a limit of 10 simultaneous
connection attempts such an application becomes unbearably slow.

Another example which shows how ridiculous this limit is in its current
implemenation is the fact that such a basic security tool as a port scanner is
practically unusable on any Windows system shipped after XP SP2.

All these problems would be non-existent if Microsoft had provided a way for
Administrators to set the limit to a value appropriate for their uses of the
OS instead of hard coding it to 10. As shown above this wouldn't have lowered
the security of the system at all. The tcpip_patcher.sys driver is meant to
provide a way to change the limit until there is an official interface to do
so.


How to build it
---------------

To build the driver itself install the DDK, open a checked or free build
environment and run

# build -ceZ

in the directory where the source files are.

To build the change_limit test application run

# cl change_limit.c advapi32.lib



