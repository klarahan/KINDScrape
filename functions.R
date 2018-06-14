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