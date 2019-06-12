
let UserWithoutTeam = {
    init(socket, element) {
        if(!element){return}
        socket.connect()
        this.onReady(socket)
    },

    onReady(socket){
        let pageContainer    =   document.getElementById("pagination-user-without-team")
        

        let user_channel = socket.channel("user:account", {})
        
        user_channel.join()
          .receive("ok", resp => { 
                user_channel.push("list_user_sin_equipo", {})
                    .receive("ok", e => 
                        this.listaUsuariosSinTeam(pageContainer, e.data)
                    )
                    .receive("error", e => console.log(e))
           })
          .receive("error", resp => { console.log("Unable to Joined Channel User Without Team", resp) })

    },
    listaUsuariosSinTeam(pageContainer, users_without_team){
        
        pageContainer.innerHTML = ''

        let result_pagination = this.paginator(users_without_team, 0, 8)

        if(result_pagination.records.length > 0){

            for (var i = 1; i <= (result_pagination.total_pages); i++) { 
                this.construirPaginado(pageContainer, this.paginator(users_without_team, i, 8))
            }

        }
        
    },
    getPageList(totalPages, page, maxLength) {
        if (maxLength < 5) throw 'maxLength must be at least 5';
    
        function range(start, end) {
            return Array.from(Array(end - start + 1), (_, i) => i + start);
        }
    
        var sideWidth = maxLength < 9 ? 1 : 2;
        var leftWidth = (maxLength - sideWidth*2 - 3) >> 1;
        var rightWidth = (maxLength - sideWidth*2 - 2) >> 1;
        if (totalPages <= maxLength) {
            // no breaks in list
            return range(1, totalPages);
        }
        if (page <= maxLength - sideWidth - 1 - rightWidth) {
            // no break on left of page
            return range(1, maxLength-sideWidth-1)
                .concat([0])
                .concat(range(totalPages-sideWidth+1, totalPages));
        }
        if (page >= totalPages - sideWidth - 1 - rightWidth) {
            // no break on right of page
            return range(1, sideWidth)
                .concat([0])
                .concat(range(totalPages - sideWidth - 1 - rightWidth - leftWidth, totalPages));
        }
        // Breaks on both sides
        return range(1, sideWidth)
            .concat([0])
            .concat(range(page - leftWidth, page + rightWidth + 2))
            .concat([0])
            .concat(range(totalPages-sideWidth+1, totalPages));
    },
    paginator(items, page, per_page) {
 
        var page = page || 1,
        per_page = per_page || 10,
        offset = (page - 1) * per_page,
       
        paginatedItems = items.slice(offset).slice(0, per_page),
        total_pages = Math.ceil(items.length / per_page);

        return {
        page_number: (page - 1),
        page_size: per_page,
        paginado: this.getPageList(total_pages, (page - 1), per_page),
        records: paginatedItems,
        total_pages: total_pages,
        total_records: items.length
        };
    },
    construirPaginado(pageContainer, {page_number, page_size, paginado, records, total_pages, total_records}){
        
        let divUsuarios = document.createElement("div")
        divUsuarios.className = "col s12 color-text-input page"
        divUsuarios.id = "page-container-" + (page_number + 1)

        if(records.length > 0){
            records.forEach(
                usuario => {
                    divUsuarios.appendChild(this.templateUsuario(usuario))
                })

            let ulPaginator = document.createElement("ul")
            ulPaginator.className = "col s12 pagination page-user-team"
    
            let templateChevronLeft = document.createElement("li")
                templateChevronLeft.id = "chevron-left-list-user";
        
                if (page_number == 0) {
                    templateChevronLeft.className = "disabled";
                    templateChevronLeft.value = "-1";
                    templateChevronLeft.innerHTML = `
                        <a><i class="material-icons">chevron_left</i></a>
                    `
                } else {
                    templateChevronLeft.className = "waves-effect";
                    templateChevronLeft.value = "" + page_number;
                    templateChevronLeft.innerHTML = `
                        <a><i class="material-icons">chevron_left</i></a>
                    `
                }
        
                ulPaginator.appendChild(templateChevronLeft)
                
                paginado.forEach(
                    pagina => {
                        ulPaginator.appendChild(this.templatePagination({pagina, page_number}))
                    })
        
                
                let templateChevronRight = document.createElement("li")
                templateChevronRight.id = "chevron-right-list-user";
        
                if ((page_number + 1) < total_pages) {
                    templateChevronRight.className = "waves-effect";
                    templateChevronRight.value = "" + page_number;
                    templateChevronRight.innerHTML = `
                        <a><i class="material-icons">chevron_right</i></a>
                    `
                } else {
                    templateChevronRight.className = "disabled";
                    templateChevronRight.value = "-1";
                    templateChevronRight.innerHTML = `
                        <a><i class="material-icons">chevron_right</i></a>
                    `
                }
        
                ulPaginator.appendChild(templateChevronRight)
                
                templateChevronLeft.addEventListener("click", e => {
                    if (templateChevronLeft.value >= 0){
                        $('.page-active').removeClass('page-active');
                        $('#page-container-'+ (templateChevronLeft.value)).addClass('page-active');
                    }
                })
        
                
                templateChevronRight.addEventListener("click", e => {
                    if (templateChevronRight.value >= 0){
                        $('.page-active').removeClass('page-active');
                        $('#page-container-'+ (templateChevronRight.value + 2)).addClass('page-active');
                    }
                })
    
            divUsuarios.appendChild(ulPaginator)
            pageContainer.appendChild(divUsuarios)
            $('#page-container-1').addClass('page-active');
        }


        
    },
    templateUsuario({id, image, mail, name, phone, surname, team_id, username}){

        // let csrfToken = document.getElementById("csrf-token")
        let template = document.createElement("div")
        template.className = "col s12 m3 div-img"
        template.style = "text-align: center;"
        template.innerHTML = `
        <label class="container-check check-new">
            <input class="container-check form-control" name="users[]" type="checkbox" value="${id}">
            <span class="checkmark"></span>
        </label>
        
        <img class="radius-img" src="http://localhost:4000/api/user-image?id=${id}"/>
        <br>
        ${username}
        `

        return template
    },
    templatePagination({pagina, page_number}){

        let templatePageNumber = document.createElement("li")
        templatePageNumber.id = "page-button";
        templatePageNumber.className = "disabled";
        templatePageNumber.value = "" + pagina - 1;

        if (pagina > 0){
            if (page_number == (pagina - 1)) {
                templatePageNumber.className = "active";
                templatePageNumber.value = "" + (pagina - 1);
                templatePageNumber.innerHTML = `
                <a>${pagina}</a>
                `
            } else {
                templatePageNumber.className = "waves-effect";
                templatePageNumber.value = "" + (pagina - 1);
                templatePageNumber.innerHTML = `
                <a>${pagina}</a>
                `
            }
        } else {
            templatePageNumber.className = "waves-effect";
            templatePageNumber.value = "-1";
            templatePageNumber.innerHTML = `
            <a style="cursor: initial;">...</a>
            `
        }

        templatePageNumber.addEventListener("click", e => {
            if (templatePageNumber.value >= 0){
                $('.page-active').removeClass('page-active');
                $('#page-container-'+ (templatePageNumber.value +1)).addClass('page-active');
            }
        })

        return templatePageNumber
    }
}
export default UserWithoutTeam