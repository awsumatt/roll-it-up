# frozen_string_literal: true

# Settings for the Roll Up Generator
ROLL_UP = './roll-up.xlsx' # Put Roll Up in folder and paste file name after the ./

MANAGEMENT_SUMMARY_V = './mgmtSumm.xlsx' # Put Management Summary V in folder and paste file name after the ./

# Settings for each store
# Must place comma after each store's curly braces {} except the last
STORES = [
  {
    name: 'chandler_ave', # No spaces or special characters except underscores
    mgmt_v_page: 2, # Page number of store in Management Summary V
    aged_receivable: './ar271.xlsx', # Put AR Report in folder and paste file name after the ./
    rollup_row: 9 # Row number of store in 'SSM Data' page of Rollup
  },
  {
    name: 'branch_ave', # No spaces or special characters except underscores
    mgmt_v_page: 1, # Page number of store in Management Summary V
    aged_receivable: './ar281.xlsx', # Put AR Report in folder and paste file name after the ./
    rollup_row: 13 # Row number of store in 'SSM Data' page of Rollup
  },
  {
    name: 'g_washington_hwy', # No spaces or special characters except underscores
    mgmt_v_page: 6, # Page number of store in Management Summary V
    aged_receivable: './ar282.xlsx', # Put AR Report in folder and paste file name after the ./
    rollup_row: 17 # Row number of store in 'SSM Data' page of Rollup
  },
  {
    name: 'main_st', # No spaces or special characters except underscores
    mgmt_v_page: 3, # Page number of store in Management Summary V
    aged_receivable: './ar283.xlsx', # Put AR Report in folder and paste file name after the ./
    rollup_row: 21 # Row number of store in 'SSM Data' page of Rollup
  },
  {
    name: 'tech_park', # No spaces or special characters except underscores
    mgmt_v_page: 4, # Page number of store in Management Summary V
    aged_receivable: './ar284.xlsx', # Put AR Report in folder and paste file name after the ./
    rollup_row: 25 # Row number of store in 'SSM Data' page of Rollup
  },
  {
    name: 'post_rd', # No spaces or special characters except underscores
    mgmt_v_page: 5, # Page number of store in Management Summary V
    aged_receivable: './ar286.xlsx', # Put AR Report in folder and paste file name after the ./
    rollup_row: 29 # Row number of store in 'SSM Data' page of Rollup
  }
]
