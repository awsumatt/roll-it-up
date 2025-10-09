# frozen_string_literal: true

require 'rubyXL'
require 'rubyXL/convenience_methods/cell'

class Writer
  def initialize(roll_up)
    @filename = roll_up
    @roll_up = RubyXL::Parser.parse(@filename)
    @ssm_data = @roll_up['SSM Data']
    @insurance = @roll_up['Insurance']
  end

  def write(store)
    write_revenue(store, store.rollup_row)
    write_receipts(store, store.rollup_row)
    write_rentals(store, store.rollup_row)
    write_ar(store, store.rollup_row)
    write_inurance(store, store.insurance_row)
    @roll_up.write(@filename)
  end

  private

  def write_cell(row, column, value)
    @ssm_data[row][column].change_contents(value, @ssm_data[row][column].formula)
  end

  def write_inurance(store, row)
    @insurance[row][2].change_contents(store.receipts[:insurance_pen], @insurance[row][2].formula)
  end

  def write_revenue(store, row)
    i = 2
    store.revenue.each_value do |value|
      write_cell(row, i, value)
      i += 1
    end
  end

  def write_receipts(store, row)
    write_cell(row, 11, store.receipts[:insurance_collected])
    write_cell(row, 24, store.receipts[:cash_receipts])
    write_cell(row, 25, store.receipts[:sales_tax])
    write_cell(row, 27, store.receipts[:nsf])
  end

  def write_rentals(store, row)
    write_cell(row, 12, store.rentals[:projected_rent])
    write_cell(row, 13, store.rentals[:new_rentals])
    write_cell(row, 14, store.rentals[:term_rentals])
    write_cell(row, 16, store.rentals[:occupied_sf])
    write_cell(row, 17, store.rentals[:occupied_ratio])
    write_cell(row, 18, store.rentals[:occupied_econ])
  end

  def write_ar(store, row)
    i = 19
    store.ar.each_value do |value|
      write_cell(row, i, value)
      i += 1
    end
  end


end
