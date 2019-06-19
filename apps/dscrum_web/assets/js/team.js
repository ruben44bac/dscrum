
let Team = {
    init(socket, element) {
        if(!element){return}
        socket.connect()
        this.onReady(socket)
    },

    onReady(socket){
        let tableContainer    =   document.getElementById("records-team")
        let paginationContainer    =   document.getElementById("pagination-team")

        let team_channel = socket.channel("team:lobby", {})
        

        team_channel.on("list", (resp) => {
            this.listaEquipos(tableContainer, paginationContainer, resp)
        })

        team_channel.join()
          .receive("ok", resp => { 
                team_channel.push("list", {})
                    .receive("ok", e => 
                    // console.log(e)
                        this.listaEquipos(socket, team_channel, tableContainer, paginationContainer, e)
                    )
                    .receive("error", e => console.log(e))
           })
          .receive("error", resp => { console.log("Unable to Joined Channel Team", resp) })
    },
    listaEquipos(socket, team_channel, tableContainer, paginationContainer, {page_number, page_size, paginado, records, total_pages, total_records}){
        
        tableContainer.innerHTML = ''
        paginationContainer.innerHTML = ''

        if(records.length > 0){
            records.forEach(
                equipo => {
                    tableContainer.appendChild(this.templateEquipo(equipo))

                    
                    if(document.getElementById(`button-delete-modal-${equipo.id}`)){
                        let modalDelete = document.getElementById(`button-delete-modal-${equipo.id}`)
                        modalDelete.addEventListener("click", e => {
                            let payload = {id: equipo.id}
                            team_channel.push("delete", payload)
                                .receive("ok", e => {
                                    $.growl.notice({ title:"Exito" ,message: "Team eliminado" });

                                    team_channel.push("list", {})
                                        .receive("ok", e => 
                                        // console.log(e)
                                            this.listaEquipos(socket, team_channel, tableContainer, paginationContainer, e)
                                        )
                                        .receive("error", e => console.log(e))

                                })
                                .receive("error", e => {
                                    if(e.errors.user != null){
                                        $.growl.error({ title:"Error" ,message: "No se permite eliminar porque tiene usuarios asociados." });
                                    }
                                    if(e.errors.story != null){
                                        $.growl.error({ title:"Error" ,message: "No se permite eliminar porque tiene historias asociadas." });
                                    }
                                    
                                })
                        })
                    }
                })
    
            let templateChevronLeft = document.createElement("li")
            templateChevronLeft.id = "chevron-left-list-team";
    
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
                    paginationContainer.appendChild(this.templatePagination(socket, team_channel, tableContainer, paginationContainer, {pagina, page_number}))
                })
    
            
            let templateChevronRight = document.createElement("li")
            templateChevronRight.id = "chevron-right-list-team";
    
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
                    team_channel.push("list", payload)
                        .receive("ok", e => 
                            this.listaEquipos(socket, team_channel, tableContainer, paginationContainer, e)
                            // templateChevronRight.value = templateChevronRight.value - 1
                            // templateChevronLeft.value = templateChevronLeft.value - 1
                        )
                        .receive("error", e => console.log(e))
                }
                
            })
    
            templateChevronRight.addEventListener("click", e => {
                if (templateChevronRight.value >= 0) {
                    let payload = {index: "" + (templateChevronRight.value + 1), size: "" + 5}
                    team_channel.push("list", payload)
                        .receive("ok", e => 
                            this.listaEquipos(socket, team_channel, tableContainer, paginationContainer, e)
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


        $("#send-button").click(function(){
            $('.modal').modal('close');
        });

        // fin modal
        
    },
    templateEquipo({id, name, users}){

        let csrfToken = document.getElementById("csrf-token")
        let template = document.createElement("tr")

        let inicio = `
        <td>
            <div class="row ">
                <div class="col s4 m4 l3">
                    <img class="radius-img" src="http://localhost:4000/api/team-image?id=${id}"/>
                </div>

                <div class="col s6 m5 l4 card-info-team">
                    <h5>${name}</h5> <br>
                </div>
                <div class="col s2 m3 l5">

                    <a class="btn-floating btn-small waves-effect waves-light purple space-top-icon tooltipped" href="/story?team_id=${id}" data-tooltip="Historias">		
                        <i class="material-icons">style</i>
                    </a>&nbsp;&nbsp;

                    <button class="btn-floating btn-small waves-effect waves-light purple space-top-icon tooltipped" data-tooltip="Detalle" data-target="modal${id}"><i class="material-icons">visibility</i></button> &nbsp;&nbsp;
                    
                    <a href="/team/${id}/edit" class="btn-floating btn-small waves-effect waves-light purple space-top-icon">
                        <i class="material-icons">edit</i>
                    </a>&nbsp;&nbsp;
                    
                    <button class="btn-floating btn-small waves-effect waves-light purple space-top-icon" data-target="modaldelete${id}"><i class="material-icons">delete</i></button> &nbsp;&nbsp;
                    
                </div>
            </div>
		
            <!-- Modal Show -->
            <div id="modal${id}" class="modal modal-me modal-team">
                <div class="modal-content">
                    <div class="row">
                        <div class="col s12" style="text-align: center;">
                            <img class="radius-img img-show-team" src="http://localhost:4000/api/team-image?id=${id}"/><br>
                            <h4> ${name} </h4>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col s12 card-info-team" style="text-align: center;">
                            <div class="row">`
                                
        let usuarios = ``

        if(users.length > 0){
            users.forEach(
                usuario => {
                    usuarios = usuarios + this.templateUsuario(usuario)
                })
        }
       

            
        template.innerHTML = inicio + usuarios +
                            
                            `
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer modal-footer-me">
                    <a id="send-button" class="modal-close btn-floating btn-small waves-effect waves-light purple space-top-icon btn-cancelar-modal">
                        <i class="material-icons">clear</i>
                    </a> 
                </div>
            </div>
            <!-- Fin Modal -->
            <!-- Modal Delete -->
            <div id="modaldelete${id}" class="modal modal-me modal-team">
                <div class="modal-content">
                    <div class="row">
                        <div class="col s12" style="text-align: center; font-size: 20px;">
                            ¿Realmente deseas eliminar al team: ${name} ? 
                        </div>
                    </div>
                </div>
                <div class="modal-footer modal-footer-me">
                        <div class="col s2 offset-s3">
                            <button class="modal-close btn-floating btn-small waves-effect waves-light purple btn-confirmar-modal space-top-icon" id="button-delete-modal-${id}">
                                <i class="material-icons">check</i>
                            </button>
                        </div>
                        <div class="col s2 offset-s2">
                            <a id="send-button" class="modal-close btn-floating btn-small waves-effect waves-light purple space-top-icon btn-cancelar-modal">
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
    templatePagination(socket, team_channel, tableContainer, paginationContainer,{pagina, page_number}){

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
                team_channel.push("list", payload)
                    .receive("ok", e => 
                        this.listaEquipos(socket, team_channel, tableContainer, paginationContainer, e)
                        // templateChevronRight.value = templateChevronRight.value + 1
                        // templateChevronLeft.value = templateChevronLeft.value + 1
                    )
                    .receive("error", e => console.log(e))
            }
        })

        return templatePageNumber
    },
    templateUsuario({id, name}){
        let templateUser = ``

        templateUser = `
            <div class="col s12 m3 div-img" style="text-align: center;">
                <img class="radius-img" src="http://localhost:4000/api/user-image?id=${id}"/>
                <br>
                ${name}
            </div>
        `

        return templateUser
    }
}
export default Team