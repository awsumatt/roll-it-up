# frozen_string_literal: true

require 'roo'

MGMT_INDEX = {
  rent: 7,
  late_lien: 8,
  merch: 9,
  fees_paid: 10,
  retained: 17,
  discounts: 14,
  fees_waived: 15,
  write_offs: 16,
  insurance_collected: 15,
  insurance_pen: 41,
  cash_receipts: 12,
  sales_tax: 14,
  nsf: 10,
  projected_rent: 24,
  new_rentals: 33,
  term_rentals: 34,
  occupied_ratio: 24,
  occupied_sf: 24,
  occupied_econ: 24
}

# This class represents a store and its financial data.
class Store
  attr_reader :revenue, :net_revenue, :receipts, :rentals, :ar, :total_ar, :rollup_row, :insurance_row

  def initialize(mgmt_report, sheet_num, aged_receivable, rollup_row, insurance_row)
    @mgmt_report = Roo::Excelx.new(mgmt_report)
    @aged_receivable = Roo::Excelx.new(aged_receivable)
    @sheet_num = sheet_num
    @sheet = @mgmt_report.sheets[@sheet_num]
    @rollup_row = rollup_row
    @insurance_row = insurance_row
    @mgmt_index = MGMT_INDEX.dup

    @sheet_num.zero? ? plus_one : nil

    pull_revenue
    pull_receipts
    pull_rentals
    pull_ar
  end

  def info
    @revenue.each do |key, value|
      puts "#{key}: $#{value}"
    end
    @receipts.each do |key, value|
      if key == :insurance_pen
        puts "#{key}: #{value * 100}%"
      else
        puts "#{key}: $#{value}"
      end
    end
    @rentals.each do |key, value|
      puts "#{key}: #{value}"
    end
    @ar.each do |key, value|
      puts "#{key}: $#{value}"
    end
  end


  private

  # First page has an extra row
  def plus_one
    @mgmt_index.each_key do |key|
      @mgmt_index[key] += 1
    end
  end

  def mgmt_cell(row, col)
    @mgmt_report.cell(row, col, @sheet)
  end

  def ar_cell(row, col)
    @aged_receivable.cell(row, col)
  end

  def pull_revenue
    @revenue = {
      rent: mgmt_cell(@mgmt_index[:rent], 'C'),
      late_lien: mgmt_cell(@mgmt_index[:late_lien], 'C'),
      merch: mgmt_cell(@mgmt_index[:merch], 'C'),
      fees_paid: mgmt_cell(@mgmt_index[:fees_paid], 'C'),
      retained: mgmt_cell(@mgmt_index[:retained], 'C'),
      discounts: mgmt_cell(@mgmt_index[:discounts], 'C'),
      fees_waived: mgmt_cell(@mgmt_index[:fees_waived], 'C'),
      write_offs: mgmt_cell(@mgmt_index[:write_offs], 'C')
    }
  end

  def pull_receipts
    @receipts = {
      insurance_collected: mgmt_cell(@mgmt_index[:insurance_collected], 'H') * -1,
      insurance_pen: mgmt_cell(@mgmt_index[:insurance_pen], 'I') / 100,
      cash_receipts: mgmt_cell(@mgmt_index[:cash_receipts], 'H'),
      sales_tax: mgmt_cell(@mgmt_index[:sales_tax], 'H'),
      nsf: mgmt_cell(@mgmt_index[:nsf], 'H')
    }
  end

  def pull_rentals
    @rentals = {
      projected_rent: mgmt_cell(@mgmt_index[:projected_rent], 'I'),
      new_rentals: mgmt_cell(@mgmt_index[:new_rentals], 'K'),
      term_rentals: mgmt_cell(@mgmt_index[:term_rentals], 'K'),
      occupied_ratio: mgmt_cell(@mgmt_index[:occupied_ratio], 'F').to_f / 100,
      occupied_sf: mgmt_cell(@mgmt_index[:occupied_sf], 'E').to_i,
      occupied_econ: mgmt_cell(@mgmt_index[:occupied_econ], 'K').to_f / 100
    }
  end

  def pull_ar
    last_row = @aged_receivable.last_row
    @ar = {
      zero_to_thirty: ar_cell(last_row, 'J'),
      thirty_to_sixty: ar_cell(last_row, 'K'),
      sixty_to_ninety: ar_cell(last_row, 'L'),
      ninety_plus: ar_cell(last_row, 'M') + ar_cell(last_row, 'N')
    }
  end

end
