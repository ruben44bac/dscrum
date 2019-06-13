
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
                })
    
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
                    story_channel.push("list", payload)
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
                    story_channel.push("list", payload)
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


        $("#send-button").click(function(){
            $('.modal').modal('close');
        });

        // fin modal
        
    },
    templateStory({id, name, date_start, date_end, difficulty_id, team_id}){

        let csrfToken = document.getElementById("csrf-token")
        let template = document.createElement("tr")
        template.innerHTML = `
        <td>
            <div class="row ">

                <div class="col s6 m6 l5 card-info-story">
                    <b>${name}</b> <br>
                </div>
                <div class="col s2 m2 l4">
                    <button class="btn-floating btn-small waves-effect waves-light purple space-top-icon" data-target="modal${id}"><i class="material-icons">visibility</i></button> &nbsp;&nbsp;
                    
                    <a href="/story/${id}/edit" class="btn-floating btn-small waves-effect waves-light purple space-top-icon">
                        <i class="material-icons">edit</i>
                    </a>&nbsp;&nbsp;
                    
                    <button class="btn-floating btn-small waves-effect waves-light purple space-top-icon" data-target="modaldelete${id}"><i class="material-icons">delete</i></button> &nbsp;&nbsp;
                    
                </div>
            </div>
		
            <!-- Modal Show -->
            <div id="modal${id}" class="modal modal-me modal-story">
                <div class="modal-content">
                    <div class="row">
                        <div class="col s12 m12 l7 offset-l2 card-info-story">
                            <b>Nombre: </b> ${name} <br>
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
                story_channel.push("list", payload)
                    .receive("ok", e => 
                        this.listaStory(socket, story_channel, tableContainer, paginationContainer, e)
                        // templateChevronRight.value = templateChevronRight.value + 1
                        // templateChevronLeft.value = templateChevronLeft.value + 1
                    )
                    .receive("error", e => console.log(e))
            }
        })

        return templatePageNumber
    }
}
export default Story