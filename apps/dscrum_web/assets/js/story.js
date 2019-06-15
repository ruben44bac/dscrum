
let Story = {
    init(socket, element) {
        if(!element){return}
        socket.connect()
        this.onReady(socket)
    },

    onReady(socket){
        let team = document.getElementById("team-id")
        let tableContainer    =   document.getElementById("records-story")
        let paginationContainer    =   document.getElementById("pagination-story")

        let story_channel = socket.channel(`history:${team.value}`, {})
        

        story_channel.on("new_story", (resp) => {
            // console.log("creada nueva historia new_story");
            // $.growl.notice({ message: "prueba" });
            // this.listaStory(tableContainer, paginationContainer, resp)
        })

        story_channel.join()
          .receive("ok", resp => { 
                story_channel.push("list_paginado", {})
                    .receive("ok", e => 
                        this.listaStory(socket, story_channel, tableContainer, paginationContainer, e)
                    )
                    .receive("error", e => console.log(e))
           })
          .receive("error", resp => { console.log("Unable to Joined Channel Story", resp) })
    },
    listaStory(socket, story_channel, tableContainer, paginationContainer, {page_number, page_size, paginado, records, total_pages, total_records}){
        
        tableContainer.innerHTML = ''
        paginationContainer.innerHTML = ''

        if(records.length > 0){
            records.forEach(
                historia => {
                    tableContainer.appendChild(this.templateStory(historia))

                    let detail_channel = socket.channel(`story_detail:${historia.id}`, {})
                        detail_channel.join()
                            .receive("ok", resp => {console.log("Joined Channel Story Detail");})
                            .receive("error", resp => { console.log("Unable to Joined Channel Story Detail", resp) })

                    if(document.getElementById(`button-show-modal-${historia.id}`)){
                        let modal = document.getElementById(`button-show-modal-${historia.id}`)
                        modal.addEventListener("click", e => {
                        
                            detail_channel.push("index", {})
                                .receive("ok", e => {
                                    
                                    let story_detail = e.data
                                    let contenidoModal = document.getElementById("modalstory")
                
                                    contenidoModal.innerHTML = ``

                                    let templateModalContent = document.createElement("div")
                                    templateModalContent.id = "modalcontent"
                                    templateModalContent.className = "modal-content"

                                                                            
                                    let dificultad_detalle = ``
                                    let finalizada = ``
                                    let detalle_historia = ``
                                    let list_users = ``

                                    dificultad_detalle = `
                                    
                                    <div class="row">
                                        <div class="col s12 m12 l3" style="text-align: center;">`

                                        if (story_detail.difficulty_id != null) {
                                            dificultad_detalle = dificultad_detalle +  `<img style="width: 110px; height: 110px;" src="http://localhost:4000/api/difficulty-image?id=${story_detail.difficulty_id}"/>`
                                        }else{
                                            dificultad_detalle = dificultad_detalle +  `<img style="width: 130px; height: 130px;" src="/images/pokemon.png"/> `
                                        }

                                        finalizada = dificultad_detalle + `
                                        </div>

                                        <div class="col s12 m12 l7 offset-l2 card-info-user">
                                            <b style="font-size: 20px;">${story_detail.name}</b> <br>
                                            Dificultad: <b>${story_detail.difficulty_name}</b> <br>
                                            Inicio: <b>${story_detail.date_start.substring(10,0)}</b>  <br>
                                            `
                                        
                                        if (story_detail.status) {
                                            finalizada = finalizada +  ` Fin: <b>${story_detail.date_start.substring(10,0)} </b><br> 
                                                                        Finalizada: <b>SI </b> <br> `
                                        }else{
                                            finalizada = finalizada +  `  Finalizada: <b>NO </b> <br>`
                                        }                    
                                                        
                                        detalle_historia = finalizada + `
                                        </div>
                                    </div> <br>`


                                        story_detail.users.forEach(
                                            usuario => {
                                                    list_users = list_users +  this.templateUser(usuario)
                                            })

                                        templateModalContent.innerHTML = detalle_historia + `<div class="row ">` + list_users + `</div>`

                                    contenidoModal.appendChild(templateModalContent)

                                    let templateModalFooter = document.createElement("div")
                                    templateModalFooter.id = "modalfooter"
                                    templateModalFooter.className = "modal-footer modal-footer-me"

                                    let aClear = document.createElement("a")
                                    aClear.id = "close-modal"
                                    aClear.className = "modal-close btn-floating btn-small waves-effect waves-light purple space-top-icon btn-cancelar-modal"

                                    aClear.innerHTML = `<i class="material-icons">clear</i>`
                                    templateModalFooter.appendChild(aClear)

                                    contenidoModal.appendChild(templateModalFooter)
                                    
                                    $("#close-modal").click(function(){
                                        $('.modal').modal('close');
                                    });

                                })
                                .receive("error", e => console.log(e))

                        })
                    }

                    
                    if(document.getElementById(`button-terminar-modal-${historia.id}`)){
                        let modalTerminar = document.getElementById(`button-terminar-modal-${historia.id}`)
                        modalTerminar.addEventListener("click", e => {
                            let payload = {id: historia.id}
                            story_channel.push("end", payload)
                                .receive("ok", e => {
                                    $.growl.notice({ title:"Exito" ,message: "Historia terminada" });

                                    story_channel.push("list_paginado", {})
                                        .receive("ok", e => 
                                            this.listaStory(socket, story_channel, tableContainer, paginationContainer, e)
                                        )
                                        .receive("error", e => console.log(e))


                                })
                                .receive("error", e => {
                                    if(e.errors.terminar != null){
                                        $.growl.error({ title:"Error",message: e.errors.terminar });
                                    }else{
                                        $.growl.error({ title:"Error",message: "Erro al terminar Historia" });
                                    }
                                    
                                })
                        })
                    }
                })

            let templateModal = document.createElement("div")
            templateModal.id = "modalstory"
            templateModal.className = "modal modal-me modal-user"
            

    
            paginationContainer.appendChild(templateModal)

    
            let templateChevronLeft = document.createElement("li")
            templateChevronLeft.id = "chevron-left-list-story";
    
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
    
            paginationContainer.appendChild(templateChevronLeft)
            
            paginado.forEach(
                pagina => {
                    paginationContainer.appendChild(this.templatePagination(socket, story_channel, tableContainer, paginationContainer, {pagina, page_number}))
                })
    
            
            let templateChevronRight = document.createElement("li")
            templateChevronRight.id = "chevron-right-list-story";
    
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
    
            paginationContainer.appendChild(templateChevronRight)

    
    
            templateChevronLeft.addEventListener("click", e => {
                if (templateChevronLeft.value >= 0) {
                    let payload = {index: "" + (templateChevronLeft.value - 1), size: "" + 5}
                    story_channel.push("list_paginado", payload)
                        .receive("ok", e => 
                            this.listaStory(socket, story_channel, tableContainer, paginationContainer, e)
                            // templateChevronRight.value = templateChevronRight.value - 1
                            // templateChevronLeft.value = templateChevronLeft.value - 1
                        )
                        .receive("error", e => console.log(e))
                }
                
            })
    
            templateChevronRight.addEventListener("click", e => {
                if (templateChevronRight.value >= 0) {
                    let payload = {index: "" + (templateChevronRight.value + 1), size: "" + 5}
                    story_channel.push("list_paginado", payload)
                        .receive("ok", e => 
                            this.listaStory(socket, story_channel, tableContainer, paginationContainer, e)
                            // templateChevronRight.value = templateChevronRight.value + 1
                            // templateChevronLeft.value = templateChevronLeft.value + 1
                        )
                        .receive("error", e => console.log(e))
                }
                
            })

        }else{
            tableContainer.innerHTML = '<h3>No existen registros<h3>'
        }

        // modal
        $(document).ready(function(){
            $('.modal').modal();
        });


        $("#cerrar-show-modal-delete").click(function(){
            $('.modal').modal('close');
        });

        // fin modal
    },
    templateStory({id, name, date_start, date_end, difficulty, difficulty_id, team_id, complete}){

        let csrfToken = document.getElementById("csrf-token")
        let template = document.createElement("tr")
        let dificultad_listado = ``

        dificultad_listado = `
        <td>
            <div class="row " style="margin-bottom: 5px !important;">

                <div class="col s12 m6 l6">
                    <div class="list-story-name"> ${name}</div>
                    <div> ${date_start} <br> ${date_end}</div>
                </div>
                <div class="col s12 m2 l2 div-img" style="text-align: end; margin-top: 10px;">`
                

        if (difficulty_id != null) {
            dificultad_listado = dificultad_listado +  `<img class="difficulty-img tooltipped" data-position="bottom" data-tooltip="${difficulty.name}" src="http://localhost:4000/api/difficulty-image?id=${difficulty.id}"/>`
        }
                    
        template.innerHTML = dificultad_listado +  ` 
                </div>
                <div class="col s12 m4 l4" style="text-align: end;">
                    <button class="btn-floating btn-small waves-effect waves-light purple space-top-icon tooltipped" data-tooltip="Detalle" id="button-show-modal-${id}" data-target="modalstory"><i class="material-icons">timeline</i></button> &nbsp;&nbsp;
                    
                    <button class="btn-floating btn-small waves-effect waves-light purple space-top-icon tooltipped" data-tooltip="Cerrar" data-target="modalterminar${id}"><i class="material-icons">gavel</i></button> &nbsp;&nbsp;

                    <button class="btn-floating btn-small waves-effect waves-light purple space-top-icon tooltipped" data-tooltip="Eliminar" data-target="modaldelete${id}"><i class="material-icons">delete</i></button> &nbsp;&nbsp;
                    
                </div>
            </div>
            <!-- Terminar Delete -->
            <div id="modalterminar${id}" class="modal modal-me modal-story">
                <div class="modal-content">
                    <div class="row">
                        <div class="col s12" style="text-align: center; font-size: 20px;">
                            ¿Realmente deseas terminar la historia: ${name} ? 
                        </div>
                    </div>
                </div>
                <div class="modal-footer modal-footer-me">
                        <div class="col s2 offset-s3">
                            <button class="modal-close btn-floating btn-small waves-effect waves-light purple btn-confirmar-modal space-top-icon" id="button-terminar-modal-${id}">
                                <i class="material-icons">check</i>
                            </button>
                        </div>
                        <div class="col s2 offset-s2">
                            <a class="modal-close btn-floating btn-small waves-effect waves-light purple space-top-icon btn-cancelar-modal">
                                <i class="material-icons">clear</i>
                            </a> 
                        </div>
                    
                </div>
            </div>
            <!-- Fin Modal -->
            <!-- Modal Delete -->
            <div id="modaldelete${id}" class="modal modal-me modal-story">
                <div class="modal-content">
                    <div class="row">
                        <div class="col s12" style="text-align: center; font-size: 20px;">
                            ¿Realmente deseas eliminar la historia: ${name} ? 
                        </div>
                    </div>
                </div>
                <div class="modal-footer modal-footer-me">
                        <div class="col s2 offset-s3">
                            <a class="btn-floating btn-small waves-effect waves-light purple btn-confirmar-modal space-top-icon" 
                                data-csrf="${csrfToken.value}"
                                data-method="delete" data-to="/story/${id}" href="/story/${id}" rel="nofollow">
                                <i class="material-icons">check</i>
                            </a>
                        </div>
                        <div class="col s2 offset-s2">
                            <a id="cerrar-show-modal-delete" class="modal-close btn-floating btn-small waves-effect waves-light purple space-top-icon btn-cancelar-modal">
                                <i class="material-icons">clear</i>
                            </a> 
                        </div>
                    
                </div>
            </div>
            <!-- Fin Modal -->

            <hr>
        </td>
        `

        return template
    },
    templatePagination(socket, story_channel, tableContainer, paginationContainer,{pagina, page_number}){

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
                let payload = {index: "" + templatePageNumber.value, size: "" + 5}
                story_channel.push("list_paginado", payload)
                    .receive("ok", e => 
                        this.listaStory(socket, story_channel, tableContainer, paginationContainer, e)
                        // templateChevronRight.value = templateChevronRight.value + 1
                        // templateChevronLeft.value = templateChevronLeft.value + 1
                    )
                    .receive("error", e => console.log(e))
            }
        })
        
        return templatePageNumber
    },
    templateUser({id, name, difficulty_id, difficulty_name, online, surname, username}){

        let templateUser = ``

        templateUser = `
            

                <div class="col s12 m6 l3" style="text-align: center;padding-top: 15px;">
                    <img class="radius-img" src="http://localhost:4000/api/user-image?id=${id}"/> <br>

                    <b>${name} </b> <br>`
                    if(difficulty_id != null){
                        templateUser = templateUser + `<b>${difficulty_name}</b>  <br>`
                    }
                    if(online){
                        templateUser = templateUser + `<b class="online-status">Online</b><br>`
                    }else{
                        templateUser = templateUser + `<b class="offline-status">Offline</b><br>`
                    }
                    templateUser = templateUser +
                    `
                </div>
        `

        return templateUser
    },
}
export default Story