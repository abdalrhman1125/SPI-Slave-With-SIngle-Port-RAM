vlib work
vlog RAM.v tb.v SPI.v SPI_WRAPPER.v
vsim -voptargs=+acc work.tb2
add wave -position insertpoint  \
sim:/tb2/DUT/RAM_inst/mem
add wave -position insertpoint  \
sim:/tb2/DUT/SPI_SLAVE_inst/cs \
sim:/tb2/DUT/SPI_SLAVE_inst/rx_data \
sim:/tb2/DUT/SPI_SLAVE_inst/rx_valid \
sim:/tb2/DUT/SPI_SLAVE_inst/tx_data \
sim:/tb2/DUT/SPI_SLAVE_inst/tx_valid
add wave *
run -all
#quit -sim