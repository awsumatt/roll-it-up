# frozen_string_literal: true

require 'io/console'
require 'json'

class String
  def bold
    "\e[1m#{self}\e[22m"
  end
  def italic
    "\e[3m#{self}\e[23m"
  end
end

done = false
config = {}
stores = []

puts "No configuration found. Running configurator...\n\n"
puts "Report configuration:\n".bold
puts 'Enter the file name of your roll-up:'
puts '(format: file-name.xlsx)'.italic
config[:roll_up] = "./#{gets.chomp}"
puts 'Enter the file name of your Management Summary V:'
config[:management_summary_v] = "./#{gets.chomp}"
puts 'Enter the file name of your Aged Receivables:'
config[:aged_receivable] = "./#{gets.chomp}"


puts "\nReports recorded.\n\n"
puts "Store configuration:\n".bold
until done
  puts 'Enter store number:'
  store_num = gets.chomp.to_i

  puts "Enter page number of Management Summary V for #{store_num}:"
  mgmt_v_page = gets.chomp.to_i

  stores << { store_num: store_num, mgmt_v_page: mgmt_v_page }
  commanded = false

  until commanded
    puts 'Type "done" if finished or "add" to add another store'
    command = gets.chomp.downcase
    case command
    when 'add'
      commanded = true
    when 'done'
      done = true
      commanded = true
    else
      puts "Unknown command: #{command}"
    end
  end
end

config[:stores] = stores

puts 'Configuration complete.'.italic
puts 'Writing configuration to config.json...'
File.write('config.json', JSON.pretty_generate(config))
puts 'Configuration written.'
