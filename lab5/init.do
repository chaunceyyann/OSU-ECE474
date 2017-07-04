add wave -position end  sim:/lab5/btn
add wave -position end  sim:/lab5/btn_state
add wave -position end  sim:/lab5/dbtn
add wave -position end  sim:/lab5/encoder
add wave -position end  sim:/lab5/encoder_state
add wave -position end  sim:/lab5/dencoder
add wave -position end  sim:/lab5/prev_state
add wave -position end  sim:/lab5/curr_state
add wave -position end  sim:/lab5/cntr
add wave -position end  sim:/lab5/clk
add wave -position end  sim:/lab5/clk_cntr
add wave -position end  sim:/lab5/clk_10k
add wave -position end  sim:/lab5/clk_1m
add wave -position end  sim:/lab5/pwm_clk_cntr
add wave -position end  sim:/lab5/pwm_cntr
add wave -position end  sim:/lab5/pwm_duty
add wave -position end  sim:/lab5/pwm
add wave -position end  sim:/lab5/led
add wave -position end  sim:/lab5/sel2
add wave -position end  sim:/lab5/sel3
add wave -position end  sim:/lab5/sseg

force -freeze sim:/lab5/clk 1 0, 0 {10 ns} -r 20
force rst 16#0
run
force rst 16#1
run
force -freeze {sim:/lab5/key} 1 0, 0 {25000000 ns} -r 50000000
force -drive sim:/lab5/btn 8'hff 0
run
force -freeze {sim:/lab5/btn[0]} 1 0, 0 {250000000 ns} -r 500000000
force -freeze {sim:/lab5/encoder[3]} 1 12500000, 0 {37500000 ns} -r 50000000
force -freeze {sim:/lab5/encoder[2]} 1 0, 0 {25000000 ns} -r 50000000
force -freeze {sim:/lab5/encoder[1]} 1 0, 0 {25000000 ns} -r 50000000
force -freeze {sim:/lab5/encoder[0]} 1 12500000, 0 {37500000 ns} -r 50000000
run 600000000
