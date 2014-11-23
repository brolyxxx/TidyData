# download the dataset

download_zip <- function(URL,zipfile) {
    
    method<-"auto" # works on Windows
    
    if (Sys.info()['sysname']=="Linux") {
        method<-"wget"
        URL<-sub("https","http",URL)
    }
    
    if(!file.exists(zipfile)) {
        download.file(url = URL,destfile = zipfile,method = method)
    }
    
    unzip(zipfile = zipfile,overwrite = FALSE)
    
}


