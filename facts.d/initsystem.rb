Facter.add(:initsystem) do
  setcode 'ls -l /proc/1/exe | awk \'{n=split($NF, N, "/"); { print N[n] }}\''
end