# frozen_string_literal: true

require 'roo'



class RowGetter
  def initialize(stores, aged_receivable, roll_up)
    @stores = stores
    @aged_receivable = Roo::Excelx.new(aged_receivable)
    @roll_up = Roo::Excelx.new(roll_up)
  end

  def find_ar_rows
    last_row = @aged_receivable.last_row
    indecies = {}
    store_num = 0
    skip = false

    (6..last_row).each do |row|
      if skip
        skip = false
        next
      end
      curr_val = @aged_receivable.cell(row, 1)
      if int_string?(curr_val)
        store_num = curr_val.to_i
      else
        indecies[store_num] = row
        skip = true
      end
    end

    indecies
  end

  def find_roll_up_rows
    num_of_stores = @stores.length
    indecies = {}
    found = 0
    row = 8

    while found < num_of_stores
      curr_val = @roll_up.cell(row, 1, 'SSM Data')
      if curr_val.is_a?(Integer)
        indecies[curr_val] = row
        found += 1
      end
      row += 1
    end

    indecies
  end

  def find_insurance_rows
    num_of_stores = @stores.length
    indecies = {}
    found = 0
    row = 5

    while found < num_of_stores
      curr_val = @roll_up.cell(row, 1, 'Insurance')
      if curr_val.is_a?(Integer)
        indecies[curr_val] = row
        found += 1
      end
      row += 1
    end

    indecies
  end

  def int_string?(val)
    Integer(val) rescue false
  end
end
