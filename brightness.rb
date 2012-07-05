#!/usr/bin/env ruby

# Author Jarmo Isotalo
# jarmo.isotalo@cs.helsinki.fi

if !ARGV[0] ||  ['-h', '--help'].include?(ARGV[0])
  puts
  puts "#{__FILE__} -i || -inc to increase screen brightness"
  puts "#{__FILE__} -d || -dec to decrease screen brightness"
  puts "no arguments"
end
@path = "/sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/intel_backlight/brightness"
@change_value = 1000
@max_value = 12421
@min_value = 1000

def read_file
  file = File.open @path.to_s, "r"
  file.gets.chop
end

@old_value = read_file.to_i
puts "old value #{@old_value}"
@to_be_value = @old_value

def value_ok?
  @to_be_value = @max_value if @to_be_value > @max_value
  @to_be_value = @min_value if @to_be_value < @min_value
  true if @to_be_value <= @max_value && @to_be_value >= @min_value
end

if ["-d", '--dec'].include?ARGV[0]
@to_be_value = @old_value - @change_value
elsif  ["-i", '--inc'].include?ARGV[0]
@to_be_value = @old_value + @change_value
end

File.open @path, "w+" do |f|
  if value_ok?
    f.rewind
    puts "new value #{@to_be_value}"
    puts "reached limit" if [@min_value, @max_value].include? @to_be_value
    f.puts @to_be_value.to_i
    f.flush
    f.close
  end
end
