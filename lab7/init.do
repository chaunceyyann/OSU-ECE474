add wave -position end  sim:/lab7/clk
add wave -position end  sim:/lab7/clk_sclk
add wave -position end  sim:/lab7/clk_bud
add wave -position end  sim:/lab7/clk_8xbud
add wave -position end  sim:/lab7/num
add wave -position end  sim:/lab7/uart_txd
add wave -position end  sim:/lab7/uart_rxd
add wave -position end  sim:/lab7/adc_rdy
add wave -position end  sim:/lab7/char_sel
add wave -position end  sim:/lab7/tx_data
add wave -position end  sim:/lab7/rx_data
add wave -position end  sim:/lab7/bud_state
add wave -position end  sim:/lab7/rx_cntr
add wave -position end  sim:/lab7/rx_bit_cntr
add wave -position end  sim:/lab7/edge_detect



force -freeze sim:/lab7/clk 1 0, 0 {10 ns} -r 20ns
force -freeze sim:/lab7/adc_rdy 1 0, 0 {2500 ns} -r 5000ns
force -freeze sim:/lab7/uart_rxd 1 8000ns, 0 {16000 ns} -r 16000ns
force rst 16#0
run
force rst 16#1
run
run 6000000ns
