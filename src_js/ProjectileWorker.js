function check_collision(x1, y1, w1, h1,  x2, y2, w2, h2) {

    var rect1 = {x: x1, y: y1, width: w1, height: h1}
    var rect2 = {x: x2, y: y2, width: w2, height: h2}

    if (rect1.x < rect2.x + rect2.width &&
            rect1.x + rect1.width > rect2.x &&
            rect1.y < rect2.y + rect2.height &&
            rect1.height + rect1.y > rect2.y) {
        return true;
    }
    return false;
}

WorkerScript.onMessage = function(message) {
    // ... long-running operations and calculations are done here
    //console.log("WorkerScript RECIEVED: " + message)
    var a_model = message.attacker_model;
    var p_model = message.projectile_model;
    for (var i=0; i<message.attacker_model.count; i++) {


        for (var p=0; p<message.projectile_model.count; p++) {

            var collision_result = check_collision(a_model.get(i).x, a_model.get(i).y, a_model.get(i).width, a_model.get(i).height, p_model.get(p).x - p_model.get(p).proximity_distance, p_model.get(p).y - p_model.get(p).proximity_distance, p_model.get(p).proximity_distance * 2, p_model.get(p).proximity_distance * 2);
            if (collision_result == true) {
                var newMsg = { "msgtype" : "hit", "id" : a_model.get(i).attacker_id, "damage" : (Math.random() * (p_model.get(i).max_damage - p_model.get(i).min_damage)) + p_model.get(i).min_damage }
                WorkerScript.sendMessage( newMsg )
            }

        }
    }
    newMsg  = { "msgtype" : "end" };
    WorkerScript.sendMessage(newMsg);

}
