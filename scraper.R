rm(list=ls())
# devtools::install_github("koheiw/RSeleniumScraper")
require(RSeleniumScraper)
source("functions.R")

open_browser("https://www.kinds.or.kr/")

# You have to move to Detail Search and select source manually

dates <- get_date_range("2013-01-01", "2013-12-31")
query <- "북한"

data <- data.frame()
for (date in dates) {
    
    set_query(query, date)
    submit()
    print_log("Searching from", format(date[1], "%F"), 'to', format(date[2], "%F"), "\n")
    
    i <- 1
    while (TRUE) {
        print_log("Download page", i, "\n")
        elems <- get_driver()$findElements('xpath', ".//h3[@class='list_newsId']")
        for (elem in elems) {
            
            # Open pop-up
            elem$clickElement()
            while(!count_elements(".//*[@id='newsPopBg' and @style='display: block;']")) {
                Sys.sleep(1)
                #print_log("Waiting for popup\n")
            }
            
            data <- rbind(data, get_article())
            
            # Close pop-up
            elem <- get_driver()$findElement('xpath', ".//div[@class='newsPopTopClose']/a")
            elem$clickElement()
            Sys.sleep(1)
            
        }
        
        i <- i + 1
        if (!count_elements(paste0(".//*[@onclick='getSearchResultNew(", i, ")']"))) {
            print_log("End of the result\n")
            Sys.sleep(1)
            break
        }
        elem <- get_driver()$findElement('xpath',  paste0(".//*[@onclick='getSearchResultNew(", i, ")']"))
        elem$clickElement()
        
        print_log("Moving to next page\n")
        Sys.sleep(3)
    }
    
    # Return to search page
    elem <- get_driver()$findElement('xpath', ".//*[@id='adjust_btn']")
    elem$clickElement()
    Sys.sleep(3)
}
