# Roll-it-Up

###### The automatic roll-up generator

## Installation

### Windows

You must use the [RubyInstaller](https://rubyinstaller.org/downloads/) in order to run the included Ruby scripts.

> **IMPORTANT:** Make sure you install the "With Devkit" version. Should be listed as `Ruby+Devkit 3.4.X (x64)`

At the end of installation, RubyInstaller will launch a command prompt window to finish. Select option **3** to ensure that you have everything you need to run the script.

Next you're going to want to download the latest release of the roll-it-up script [here](https://github.com/awsumatt/roll-it-up/releases/tag/v1.0). You will then go to where you downloaded the `.zip`, right click on it, and select "**Extract All...**". I recommend clicking **Browse** and selecting your **Downloads** folder for the location to make it easy to drag your reports in.

Lastly, we need to pull down a couple modules for reading and writing to the Excel sheets. Navigate to the `roll-it-up_1.0` folder that you just extracted. Right click inside the folder and select "**Open in Terminal**". This should open a PowerShell instance where you can run the following command: `bundle install`. The  modules will be pulled down automatically and you are ready to rock!



## Usage

### Configuration

All configuration options are contained within `config.json`. For Roll-it-Up to work properly, you must tell it where each report is and which row of the SSM data each store falls on. An example configuration below:

> Prior to configuring, place all reports inside the `roll-it-up_1.0` folder. Consider renaming each report to omit any spaces so they can be easily entered into the config.

```js
{
  "roll_up": "./file-name.xlsx",              // Exact filename of Roll Up
  "management_summary_v": "./file-name.xlsx", // Exact filename of Management Summary V
  "stores": [
    {                                         // Store name. Can be anything as
      "name": "store100",                     // long as it contains no  spaces.
      "mgmt_v_page": 1,
      "aged_receivable": "./file-name.xlsx",  // Exact filename of aged receivable
      "rollup_row": 4
    },
    {
      "name": "store101",
      "mgmt_v_page": 2,                        // Page of MGMT Summary V that store is on
      "aged_receivable": "./file-name.xlsx",
      "rollup_row": 8                          // Row of 'SSM Data' that Store is on inside Roll-up
    }, // Each store except for the last requires a comma after the curly braces
    {
      "name": "store102",
      "mgmt_v_page": 3,
      "aged_receivable": "./file-name.xlsx",
      "rollup_row": 12
    }
  ]
}

```

As long as you maintain consistent file names, this configuration only needs to be done once. The only bottleneck now is getting the reports out of SSM, Roll-it-Up takes care of the data entry!

### Usage

> Note: To avoid issues, it is recommended that you close your Roll-Up in Excel before running Roll-it-Up

To see it in action, right click inside the folder and select "**Open in Terminal**". Run the command `ruby main.rb`. As long as you have configured it with the correct reports, Roll-it-Up will read your management summary and aged receivables, open your roll-up, and then write in the data for each store.
