subsetLidar <- function(data, input.filepath, output.path){
  # Subset a las data set for ground and canopy returns and write results to
  # a shape file. Optionally, eturn the data.
  #
  # Args:
  #   data: LAS data
  #   input.filepath: Full path and name of the input LAS data file
  #   output.path: Full path to where the output file should be written
  #   return.data: return data subsets (true/false)
  #
  # Returns: las data as spatial data frame (optionally)
  #
  #  Copyright (C) 2014 Thomas Nauss
  #
  #  This program is free software: you can redistribute it and/or modify
  #  it under the terms of the GNU General Public License as published by
  #  the Free Software Foundation, either version 3 of the License, or
  #  (at your option) any later version.
  #
  #  This program is distributed in the hope that it will be useful,
  #  but WITHOUT ANY WARRANTY; without even the implied warranty of
  #  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  #  GNU General Public License for more details.
  #
  #  You should have received a copy of the GNU General Public License
  #  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  #
  #  Please send any comments, suggestions, criticism, or (for our sake) bug
  #  reports to admin@environmentalinformatics-marburg.de

  output.filepath.prefix <- paste0(output.path, "/",
                                   substr(basename(input.filepath), 1,
                                          nchar(basename(input.filepath)) -4))
  class <- c(2, 13)
  sapply(class, function(x){
    act.subset <- subset(data, data$CfN == x)
    output.filepath <- paste0(output.filepath.prefix,sprintf("_cid%02d", x))
    writeOGR(act.subset, output.filepath,
             layer = basename(output.filepath),
             driver="ESRI Shapefile")
  })
}
