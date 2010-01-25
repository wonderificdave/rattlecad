array set ABC {
           01   anton
           02   berta
           03   caesar
           04   dora
           }
           
puts "\n--------------------------\n"
puts " [array statistics ABC]"
puts "\n--------------------------\n"
foreach id [array names ABC] {
    puts "    ->  $id    $ABC($id)"
}

puts "\n--------------------------\n"

unset ABC(02)

foreach id [array names ABC] {
    puts "    ->  $id    $ABC($id)"
}

puts "\n--------------------------\n"

unset ABC

foreach id [array names ABC] {
    puts "    ->  $id    $ABC($id)"
}

puts  "\n--------------------------\n"
