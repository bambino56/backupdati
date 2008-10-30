#!/usr/bin/ruby

require 'FileUtils'
require 'rubyscript2exe'

RUBYSCRIPT2EXE.bin = ['robocopy.exe']
exit if RUBYSCRIPT2EXE.is_compiling?

username     = ENV['USERNAME']
computername = ENV['COMPUTERNAME']
src          = ENV['USERPROFILE']
dstdrive     = 'Y:'
dstpath      = "\\backup\\#{computername}\\#{username}\\Documents and Settings"
dst          = dstdrive + dstpath

puts '#######'
puts '#'
puts '#  Questo programma avviera` robocopy per'
puts '#  effettuare il backup dei dati e documenti'
puts '#  dell\'utente corrente di Windows'
puts "#  #{src}"
puts "#  sull\'unita` di rete #{dstdrive} in"
puts "#  #{dst}"
puts '#'
puts '#######'

puts
print 'Premere un tasto per avviare il backup... '
$stdout.flush
$stdin.gets
puts

puts '#######'
puts '#'
puts '#  Backup in corso. Attendere...'
puts '#'
puts '#######'

FileUtils.mkdir_p dst

output = `robocopy.exe "#{src}" "#{dst}" /E /R:0 /NP /NS`

output.split.each do |line|
  if line =~ /^\s+(New File|Newer)/
    puts line.strip
  end
end

puts '#######'
puts '#'
puts '#  Backup terminato.'
puts '#'
puts '#######'

puts
print 'Premere un tasto per uscire... '
$stdout.flush
$stdin.gets
puts
