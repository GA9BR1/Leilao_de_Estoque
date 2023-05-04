# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "slim-select", to: "https://ga.jspm.io/npm:slim-select@2.4.5/dist/slimselect.es.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"