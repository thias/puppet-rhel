# Simple fact to get RHEL kernel major release version
require 'facter'

kernel_release = Facter::Util::Resolution.exec('uname -r 2>&1')

# RHEL kernel releases are semi-semantic, initially x then x.y.z (y.z optional)
if kernel_release =~ /^\d+\.\d+\.\d+-\d+(\.\d+\.\d+)?\.el/
  Facter.add(:rhel_kernelrelease) { setcode { kernel_release[/^\d+\.\d+\.\d+-(\d+)/, 1] } }
  Facter.add("rhel#{Facter.value(:operatingsystemmajrelease)}_kernelrelease") { setcode { kernel_release[/^\d+\.\d+\.\d+-(\d+)/, 1] } }
end

