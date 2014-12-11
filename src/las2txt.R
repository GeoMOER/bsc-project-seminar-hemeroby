las2txt <- function(input.filepath, output.path, liblas.path,
                    create.shape = FALSE, return.data = FALSE){
  # Convert LAS data from HVBG, ETRS89/UTM 32 north, to a txt file.
  # Optionally, the LAS content is converted to an ESRI shape
  # file and returend as data rame.
  #
  # Args:
  #   input.filepath: Full path and name of the input LAS data file
  #   output.path: Full path to where the output file should be written
  #   liblas.path: Path to the liblas library
  #   create.shape: Write las data to shape file
  #   return.data: return LAS data (true/false)
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
  las2txt.exe <- dsn <- switch(Sys.info()[["sysname"]],
                               "Linux" = paste0(liblas.path, "/las2txt"),
                               "Windows" = paste0(liblas.path, "/las2txt.exe"))

  cmd <- paste0(las2txt.exe, " -i ", input.filepath, " --parse xyzinrc -o ",
                output.filepath.prefix, ".txt")
  system(cmd)

  if(create.shape == TRUE | return.data == TRUE){
    data <- read.table(paste0(output.filepath.prefix, ".txt"),
                       header = TRUE, sep = ",")
    colnames(data) <- c("X", "Y", "Z", "Int", "NoR", "RN", "CfN")
    coordinates(data) <- ~X + Y
    projection(data) <- "+proj=utm +zone=32 +ellps=GRS80 +units=m +north"
    if(create.shape == TRUE){
      writeOGR(data, output.filepath.prefix,
               layer = basename(output.filepath.prefix),
               driver="ESRI Shapefile")
    }
    if(return.data == TRUE){
      return(data)
    } else{
      return()
    }
  }
}
