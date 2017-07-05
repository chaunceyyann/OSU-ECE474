add wave -position end  sim:/bcd/btn
add wave -position end  sim:/bcd/btn_state
add wave -position end  sim:/bcd/dbtn
add wave -position end  sim:/bcd/tdbtn
add wave -position end  sim:/bcd/inc
add wave -position end  sim:/bcd/cntr
add wave -position end  sim:/bcd/clk
add wave -position end  sim:/bcd/clk_cntr
add wave -position end  sim:/bcd/clk_1k
add wave -position end  sim:/bcd/key
add wave -position end  sim:/bcd/pwm_duty
add wave -position end  sim:/bcd/pwm
add wave -position end  sim:/bcd/led
add wave -position end  sim:/bcd/sel2
add wave -position end  sim:/bcd/sel3
add wave -position end  sim:/bcd/sseg

force -freeze sim:/bcd/clk 1 0, 0 {10 ns} -r 20
force rst 16#0
run
force rst 16#1
run
force -drive sim:/bcd/key 1'h1 0
force -drive sim:/bcd/btn 8'hff 0
run
force -freeze {sim:/bcd/btn[3]} 1 0, 0 {25000000 ns} -r 50000000
force -freeze {sim:/bcd/btn[7]} 1 0, 0 {100000000 ns} -r 200000000
run 600000000
