rm(list=ls())
# devtools::install_github("koheiw/RSeleniumScraper")
require(RSeleniumScraper)

set_directory("data") # we do not use this directory for KINDS
open_browser("https://www.kinds.or.kr/")

# You have to move to Detail Search and select source manually

# elem <- get_driver()$findElement('xpath', ".//li[@class='topMenu1']")
# elem$clickElement()
# Sys.sleep(1)

set_query <- function(query, date) {
    elem <- get_driver()$findElement('xpath', ".//*[@id='searchDetailTxt1']")
    elem$clearElement()
    elem$sendKeysToElement(list(query))
    
    elem <- get_driver()$findElement('xpath', ".//*[@id='fromdate']")
    elem$clearElement()
    elem$sendKeysToElement(list(date[1]))
    
    elem <- get_driver()$findElement('xpath', ".//*[@id='todate']")
    elem$clearElement()
    elem$sendKeysToElement(list(date[2]))
}

submit <- function() {
    Sys.sleep(1)
    elem <- get_driver()$findElement('xpath', ".//*[@id='searchSubmit']")
    elem$clickElement()
}

get_article <- function() {
    # Extract data
    date <- ""
    
    # Extract heading
    elem <- get_driver()$findElement('xpath', ".//*[@id='pop_newsTitle']")
    head <- elem$getElementText()[[1]]
    
    # Extract body
    elem <- get_driver()$findElement('xpath', ".//*[@id='pop_newsContent']")
    body <- elem$getElementText()[[1]]
    
    data.frame(page = i, head, body, date, stringsAsFactors = FALSE)
}

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
