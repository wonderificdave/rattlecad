

array set CURRENT_Config {
                       GUI_Font               {Arial 8}
                       GUI_METH_BBracket      {height}
                       Values {}
}

puts [array names CURRENT_Config]

array set values_00 {
                       value_1  34.5
                       value_2  89.2
                       value_3   4.5
}

puts [array statistics CURRENT_Config]

