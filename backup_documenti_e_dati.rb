#!/usr/bin/ruby
# Mi piacerebbe cambiare questo file in git

require 'rubygems'
#require 'FileUtils'
require 'rubyscript2exe'
require 'cmdparse'

using_iteration = true

RUBYSCRIPT2EXE.bin = ['robocopy.exe']
exit if RUBYSCRIPT2EXE.is_compiling?

username     = ENV['USERNAME']
computername = ENV['COMPUTERNAME']
src          = ENV['USERPROFILE']
dstdrive     = 'Y:'
dstpath      = "\\backup\\#{computername}\\#{username}\\Documents and Settings"


# qui mettiamo un cmd parser
cmd = CmdParse::CommandParser.new( true, true )
# aggiunge l'help
cmd.add_command( CmdParse::HelpCommand.new, true )
cmd.program_name = "backup_documenti_e_dati"
cmd.program_version = [0,1,0]
cmd.add_command( CmdParse::VersionCommand.new )

roborun = CmdParse::Command.new( 'run', false )
roborun.short_desc = "Backup dei dati su Y:"
roborun.description = "Questo programma avvia robocopy per'"
roborun.description << "effettuare il backup dei dati e documenti"
roborun.description << " dell'utente corrente di Windows"

roborun.options = CmdParse::OptionParserWrapper.new do |opt|
  opt.on( '-n', '--noitaration',
  'Non usa iterazione con l\'utente' ) { |iter| using_iteration=false }
  opt.on( '-d', '--destination SECTION',
    'usa un altro drive come destinazione' ) { |section| dstdrive=section }
end

roborun.set_execution_block do |args|
  dstdrive += ':' if dstdrive.length == 1
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

  if using_iteration
    puts
    print 'Premere un tasto per avviare il backup... '
    $stdout.flush
    $stdin.gets
    puts
  end

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

  if using_iteration
    puts
    print 'Premere un tasto per uscire... '
    $stdout.flush
    $stdin.gets
    puts
  end
end #roborun execution block

cmd.add_command(roborun, true) # default command

cmd.parse