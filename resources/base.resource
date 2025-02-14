*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BROWSER}                 chrome 
${URL}                     http://www.amazon.com.br
${MENU_ELETRONICOS}        //a[@href='/Eletronicos-e-Tecnologia/b/?ie=UTF8&node=16209062011&ref_=nav_cs_electronics']
${HEADER_ELETRONICOS}      //h1[contains(.,'Até 25% off em Eletrônicos e TVs | Esquenta Black Friday')]
${BTN_ADD_CARRINHO}        add-to-cart-button
${NAO_OBRIGADO}            //input[contains(@aria-labelledby,'attachSiNoCoverage-announce')]
${ADICIONADO_NO_CARRINHO}  //h1[@class='a-size-medium-plus a-color-base sw-atc-text a-text-bold'][contains(.,'Adicionado ao carrinho')]
${CARRINHO}                nav-cart-count
${EXCLUIR}                 //input[contains(@value,'Excluir')]
${REMOVIDO_DO_CARRINHO}    //h1[@class='a-spacing-mini a-spacing-top-base'][contains(.,'Seu carrinho de compras da Amazon está vazio.')]


*** Keywords ***
Abrir o navegador
    Open Browser    browser=${BROWSER}
    Maximize Browser Window

Fechar o navegador
    Capture Page Screenshot
    Close Browser

#Caso de Teste 01 - Acesso ao menu "Eletrônicos"
Dado que estou na home page da Amazon.com.br
    Go To    url=${URL}
    Wait Until Element Is Visible    locator=${MENU_ELETRONICOS}

Quando acessar o menu "Eletrônicos"
    Click Element    locator=${MENU_ELETRONICOS}

Então o título da página deve ficar "${FRASE}"
    Wait Until Page Contains    text=${FRASE}
   
    
E o texto "Até 25% off em Eletrônicos e TVs | Esquenta Black Friday" deve ser exibido na página
    Wait Until Element Is Visible    locator=${HEADER_ELETRONICOS} 
E a categoria "${NOME_CATEGORIA}" deve ser exibida na página
    Element Should Be Visible    locator=//span[@class='dcl-truncate'][contains(.,'${NOME_CATEGORIA}')]
    

#Caso de Teste 02 - Pesquisa de um Produto
Quando pesquisar pelo produto "${PRODUTO}"
    Input Text    locator=twotabsearchtextbox    text=${PRODUTO}

E clicar no botão de pesquisa
    Click Element    locator=nav-search-submit-button

E um produto da linha "${PRODUTO}" deve ser mostrado na página
    Wait Until Element Is Visible    locator=(//span[contains(.,'${PRODUTO}')])[3]

#Caso de Teste 03 - Adicionar Produto no Carrinho
E adicionar o produto "${PRODUTO}" no carrinho
    Click Element    locator=//span[@class='a-size-base-plus a-color-base a-text-normal'][contains(.,'${PRODUTO}')]   
    Wait Until Element Is Visible                                              locator=${BTN_ADD_CARRINHO}
    Click Button                                                               locator=${BTN_ADD_CARRINHO}
    Wait Until Page Contains Element                                           locator=${NAO_OBRIGADO}        timeout=10s
    Run Keyword And Ignore Error          Wait Until Element Is Visible        locator=${NAO_OBRIGADO}        timeout=5s
    Click Button                                                               locator=${NAO_OBRIGADO}

Então o produto "${PRODUTO}" deve ser mostrado no carrinho
    Wait Until Element Is Visible        locator=${ADICIONADO_NO_CARRINHO}
    Wait Until Page Contains             Adicionado ao carrinho    timeout=10s 
    
#Caso de Teste 04 - Remover Produto do Carrinho
E verifico o produto "${PRODUTO}" no carrinho
    Wait Until Element Is Visible         locator=${BTN_ADD_CARRINHO}
    Click Button                          locator=${BTN_ADD_CARRINHO}
                                                       
E clicar no carrinho com produto adicionado
    Click Button                          nav-cart

E clicar no Excluir produto
    Click Element   locator=${EXCLUIR}

Então o carrinho deve ficar vazio
    Wait Until Page Contains             Seu carrinho de compras da Amazon está vazio.    timeout=10s 

