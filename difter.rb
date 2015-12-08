#!/usr/bin/env ruby
require 'pry'
require 'find'
require_relative 'difter_defs'
require_relative 'progress_meter'

[ARGV[0] || master_branch,
ARGV[1] || current_branch]
.each_with_index{ |branch, i|
  puts "branch#{i+1} " +
    " is #{branch} (#{sha_of branch})"
  puts "\n"
}
.tap{|branches|
  @branches = branches
  files_changed(*branches)
  .tap{|files_changed_between_branches|
    puts "the files that changed are: \n" +
    files_changed_between_branches.join("\n")
    puts "\n"
  }
  .map{|file| CucumberFile[file]}
  .select(&:is_step_file?)
  .tap{|files|
    if debug=false
      puts "\n"
      puts "but only"
      files.each do |file|
        puts "#{file} " +
          "is a step definition file"
      end
      puts "\n"
    end
  }
}
.tap{|branches|
  @old_branch, @new_branch = *branches
  checkout @old_branch
  @old_steps = all_steps
  @old_code = all_code

  checkout @new_branch
  @new_steps = all_steps
  @new_code = all_code
}
.tap{|branches|
  # go back to the first branch
  checkout @old_branch
}

# get changed steps
changed_steps = []
@new_code.each do |new_deff,new_code|
  if @old_code.include?(new_deff)
    if new_code != @old_code[new_deff]
      changed_steps << new_deff
    end
  else
    changed_steps << new_deff
  end
end
changed_steps.flatten!

puts "finding scenarios..."
progress = progress_meter changed_steps.size

scenarios = []
changed_steps.each_with_index do |stip,i|
  scenarios << get_scenarios_for_step(
    stip, @new_steps
  )
  print progress.(i)
end
print progress.(:done)
scenarios.flatten!


# switch back to original branch
checkout @branches.last

tempid = `echo $$`.chomp
output_file = "#{tempid}-difter.scenarios"
output_file_of_wips = "#{tempid}-difter.wipped_scenarios"

File.open(output_file, 'a') do |file|
  file.puts scenarios
    .reject{|file| Scenario[file].is_wipped?}
    .sort.uniq * "\n"
end

File.open(output_file_of_wips, 'a') do |file|
  file.puts scenarios
    .select{|file| Scenario[file].is_wipped?}
    .sort.uniq * "\n"
end

puts "\n"
puts "these scenarios use the changed steps but are wipped:"
puts `cat #{output_file_of_wips}`
puts "\n"
puts "these scenarios use the changed steps:"
puts `cat #{output_file}`
puts "\n"
puts "cat #{output_file}"

