
let StoryForm = {
    init(socket, element) {
        if(!element){return}
        socket.connect()
        this.onReady(socket)
    },

    onReady(socket){
        let submit = document.getElementById("msg-submit-story")

        let team_id = document.getElementById("team-id")
        let story_name = document.getElementById("story_name")
        let story_date_start = document.getElementById("story_date_start")

        let story_channel = socket.channel(`history:${team_id.value}`, {})
        

        submit.addEventListener("click", e => {
            let payload = {name: story_name.value, date_start: new Date(story_date_start.value), team_id: team_id.value}
            console.log(payload);
            story_channel.push("add", payload)
                .receive("ok", e => console.log(e))
                .receive("error", e => console.log(e))
            
        })

        story_channel.on("new_story", (resp) => {
            // console.log("creada nueva historia new_story");
            $.growl.notice({ message: "prueba" });
            // this.listaUsuarios(tableContainer, paginationContainer, resp)
        })

        story_channel.join()
          .receive("ok", resp => { 
                console.log("Joined Channel StoryForm");
           })
          .receive("error", resp => { console.log("Unable to Joined Channel StoryForm", resp) })
    }
}
export default StoryForm