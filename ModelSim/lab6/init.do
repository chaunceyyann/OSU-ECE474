add wave -position end  sim:/lab6/clk
add wave -position end  sim:/lab6/clk_2d5m
add wave -position end  sim:/lab6/adc_Dout
add wave -position end  sim:/lab6/adc_Din
add wave -position end  sim:/lab6/adc_data
add wave -position end  sim:/lab6/adc_ch_s

force -freeze sim:/lab6/clk 1 0, 0 {10 ns} -r 20ns
force -freeze sim:/lab6/adc_Dout 1 20, 0 {420 ns} -r 800ns
force rst 16#0
run
force rst 16#1
run
force -drive sim:/lab6/btn 8'hff 0
run 6000000ns
