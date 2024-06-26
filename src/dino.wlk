import wollok.game.*
    
const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
	
		keyboard.space().onPressDo{ self.jugar()}
		keyboard.up().onPressDo{ dino.saltar()}
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
		
	} 
	
	method iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		cactus.detener()
		reloj.detener()
		dino.morir()
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
	

}

object reloj {
	
	var property tiempo = 0
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo += 0.1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		//COMPLETAR
	}
		method chocar(){
		dino.morir()
	}
}

object cactus {
	 
	var position = self.posicionInicial()

	method image() = "cactus.png"
	method position() = position
	
	method posicionInicial() = game.at(game.width()-1,suelo.position().y())

	method iniciar(){
		position = self.posicionInicial()
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}
	
	method mover(){
		if (self.position().left(1).x().between(0, game.width()-1)){
		position=self.position().left(1)}
		else{position = self.posicionInicial()}	
	}
	
	method chocar(){
		//COMPLETAR
	}
    method detener(){
		//COMPLETAR
	}
}

object suelo{
	
	method position() = game.origin().up(1)
	
	method image() = "suelo.png"
}


object dino {
	var vivo = true

	var position = game.at(1,suelo.position().y())
	
	method image() = "dino.png"
	method position() = position
	
	method saltar(){
		//if(position == game.at(1,suelo.position().y())){
			self.subir()
			game.schedule(400, {=>self.bajar()})			
		//}
	}

	
	method subir(){
		position = position.up(2)
	}
	
	method bajar(){
		position = position.down(2)
	}
	method morir(){
		game.say(self,"¡Auch!")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}