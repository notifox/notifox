require 'set'

def current_branch
  `git status --branch | head -n1 | awk '{print $NF}'`.chomp
end

def master_branch
  'master'
end

def checkout branch
  `git checkout #{branch}`
end

def sha_of branch
  `git rev-parse #{branch}`.chomp
end

def files_changed(branch1, branch2)
  `git diff #{branch1}..#{branch2} --name-only`.split("\n")
end

class CucumberFile
  attr_accessor :file
  def initialize(file)
    @file = file
  end
  def is_step_file?
    file =~ /steps\.rb/
  end
  def self.[] file
    CucumberFile.new file
  end
  def to_s
    file
  end
  def to_str
    file
  end
end

class Scenario
  attr_accessor :file, :line, :read_file
  def initialize(file_colons)
    @file, @line = file_colons.split(":")
    @line = @line.to_i - 1
    @read_file = File.open(file).readlines
  end
  def self.[] file_colons
    Scenario.new file_colons
  end
  def is_wipped?
    [line_above_scenario, first_line].any?{|l| l =~ /wip/}
  end
  def current_line
    read_file[line]
  end
  def line_above_scenario(start=line)
    if read_file[start] =~ /Scenario/
      read_file[start - 1]
    else
      line_above_scenario(start - 1)
    end
  end
  def first_line
    read_file[0]
  end
end

def load_file(file)
  IO.readlines(file).map{|line| line.chomp}
end

def all_feature_files
  Find.find('features').select { |filepath| filepath =~ /\w\.feature$/ }
end

def all_step_files
  Find.find('features').select { |filepath| filepath =~ /steps\.rb$/ }
end

def steps_from_feature_file(file)
  is_scenario = ->(line){line =~ /Scenario/}
  is_scenario_outline = ->(line){line =~ /Scenario Outline:/}
  is_examples = ->(line){line =~ /\s*Examples:/}
  is_background = ->(line){line =~ /Background:/}
  is_stepline = ->(line){line =~ /\s*(?:Given|When|Then|And|But)/}

  steps = []
  current_scenario = {}
  lines = IO.readlines file
  lines.each_with_index do |line, i|
    line.strip!
    if is_background.(line)
      current_scenario = {line: line, lineno: 1} # mark the whole file
    end
    if is_scenario.(line)
      current_scenario = {line: line, lineno: i+1}
    end
    if is_scenario_outline.(line)
      current_scenario = {line: line, lineno: i+1, outline: true}
    end
    if is_stepline.(line)
      steps << {
        line: line,
        lineno: i+1,
        scenario: current_scenario[:line],
        scenario_lineno: current_scenario[:lineno],
        feature_file: file,
      }
    end
    if is_examples.(line)
      current_scenario = {line: line, lineno: i+1, examples: true}
    end
  end
  steps
end

def all_steps
  all_feature_files.map do |file|
    steps_from_feature_file(file)
  end.flatten!
end

def all_code
  all_step_files.map do |file|
    regexes, code = parse_step_definitions(load_file(file))
    code
  end.inject(&:merge!)
end

def all_regexes
  all_step_files.map do |file|
    regexes, code = parse_step_definitions(load_file(file))
    regexes
  end.flatten!
end

def parse_step_definitions(lines_of_code)
  stepstart = ->(line){line =~ /^(?:Given|When|Then|And|But)/}
  stepend = ->(line){line =~ /^end/} # assumes standard indentation

  steps = {}
  setps = Set.new
  current_step = ""
  lines_of_code.each do |line|
    if stepstart.(line)
      current_step = line
      setps.add line
      steps[line] ||= []
    end
    if !current_step.empty?
      steps[current_step] << line
    end
    if stepend.(line)
      current_step = ""
    end
  end
  [setps,steps]
end

def get_scenarios_for_step(stip, steps)
  regexp_of_step = ->(stip){stip =~ /\/(.*)\//;Regexp.new($1)}
  body_of_step = ->(line){line.split.drop(1).join(" ")}

  scenarios = []
  steps.each_with_index do |a_step,i|
    if body_of_step.(a_step[:line]) =~ regexp_of_step.(stip)
      scenarios << "#{a_step[:feature_file]}:#{a_step[:scenario_lineno]}"
    end
  end
  scenarios
end
