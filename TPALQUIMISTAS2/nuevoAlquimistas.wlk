object alquimista {
  var itemsDeCombate = []
  var itemsDeRecoleccion = []
  
 //----------------------------------------------------- PUNTO 1
  method tieneCriterio() {
    return self.cantidadDeItemsDeCombateEfectivos() >= self.cantidadDeItemsDeCombate() / 2
  }
  
  method cantidadDeItemsDeCombate() {
    return itemsDeCombate.size()
  }
  
  method cantidadDeItemsDeRecoleccion() {
    return itemsDeRecoleccion.size()
  }
  
  method cantidadDeItemsDeCombateEfectivos() {
    return itemsDeCombate.count({ itemDeCombate =>
      itemDeCombate.esEfectivo()
    })
  }
  
  method agregarItemDeCombate(itemDeCombate){
  	itemsDeCombate.add(itemDeCombate)
  }
  
  method agregarItemDeRecoleccion(itemDeRecoleccion){
  	itemsDeRecoleccion.add(itemDeRecoleccion)
  }
 
 //------------------------------------------------------ PUNTO 2
 method esBuenExplorador(){
 	return self.cantidadDeItemsDeRecoleccion() >= 3
 	}
 
 //------------------------------------------------------ PUNTO 3	
 method capacidadOfensiva(){
 	return itemsDeCombate.sum({itemDeCombate => itemDeCombate.capacidadOfensiva()})
 }

 // ---------------------------------------------------- PUNTO 4
 method esProfesional(){
 	return self.calidadDeItemsMayorA50() and self.todosItemsDeCombateEfectivos() and self.esBuenExplorador() 
 }	
 
 method todosItemsDeCombateEfectivos(){
 	return itemsDeCombate.all({itemDeCombate => itemDeCombate.esEfectivo()})
 }
 
 method calidadDeItemsMayorA50(){
 	return self.calidadPromedio() > 50
 }
 
 method calidadPromedio(){
 	return self.sumaDeCalidades() / self.cantidadDeItemsTotales()
 }
 
 method sumaDeCalidades(){
 	return self.calidadItemsDeRecoleccion() + self.calidadItemsDeCombate()
 }
 
 method calidadItemsDeRecoleccion(){
 	return itemsDeRecoleccion.sum({itemDeRecoleccion => itemDeRecoleccion.calidad()}) 
 	//return 30 + itemsDeRecoleccion.sum({itemDeCombate => itemDeCombate.calidad()}) /10
 }
 
 method calidadItemsDeCombate(){
 	return itemsDeCombate.sum({itemDeCombate => itemDeCombate.calidad()}) 
 }
 
 method cantidadDeItemsTotales(){
 	return self.cantidadDeItemsDeRecoleccion() + self.cantidadDeItemsDeCombate()
 }
 
}

object bomba {
  var danio = 150
  var materiales = []
  
  method esEfectivo() {
    return danio > 100
  }
  
  method dejarEnCero() {
  	danio = 0
  }
  
  method agregarMaterial(unMaterial){
  	materiales.add(unMaterial)
  }
  
  method capacidadOfensiva(){
  	return danio / 2
  }
  
  method calidad(){
  	return self.calidadDelMaterialConMenorCalidad()
  }
  
  method calidadDelMaterialConMenorCalidad(){
  	return materiales.min({material => material.calidad()}).calidad()
  }
}

object pocion {
  var materiales = []
  var poderCurativo = 60
  
  method esEfectivo() {
    return poderCurativo > 50 and self.fueCreadaConAlgunMaterialMistico()
  }
  
  method cantidadDeMaterialesMisticos() {
  	return materiales.count({materialMistico => materialMistico.esMistico()})
  }
  
  method agregarMaterial(material){
  	materiales.add(material)
  }
  
  method fueCreadaConAlgunMaterialMistico() {
    return materiales.any({ material =>
      material.esMistico()
    })
  }
  
  method dejarEnCero() {
  	poderCurativo = 0
  }
  
  method capacidadOfensiva (){
  	return poderCurativo + self.puntosExtra()
  }
  
  method puntosExtra(){
  	return self.cantidadDeMaterialesMisticos() * 10
  }
  
  method calidadDelPrimerMaterialMistico(){
  	return self.primerMaterialMistico().calidad()
  }
  
  method primerMaterialMistico(){
  	return materiales.find({material => material.esMistico()})
  }
  
  method calidadDelPrimerMaterial(){
  	return self.primerMaterial().calidad()
  }
  
  method primerMaterial(){
  	return materiales.first()
  }
  
  method calidad(){
  	if(self.fueCreadaConAlgunMaterialMistico()){
  		return self.calidadDelPrimerMaterialMistico()
  	} return self.calidadDelPrimerMaterial()
  }
 }


object debilitador {
  var materiales = []
  var potencia = 0
  
  method esEfectivo() {
    return potencia > 0 and self.fueCreadoPorAlgunMaterialMistico().negate()
  }
  
  method fueCreadoPorAlgunMaterialMistico() {
    return materiales.any({ material =>
      material.esMistico()
    })
  }
  
  method contieneMaterialMistico(){
  	 return materiales.any({ material =>
      material.esMistico()
    })
  }
  
  method cantidadDeMaterialesMisticos(){
  	return materiales.count({materialMistico => materialMistico.esMistico()})
  }
  
  method agregarMaterial(material){
  	materiales.add(material)
  }
  
  method capacidadOfensiva(){
  	if(self.contieneMaterialMistico()){
  		return 12 * self.cantidadDeMaterialesMisticos()
  	}
  	return 5
  }
  
  method calidad(){
  	return self.dosItemsDeMayorCalidad() / 2
  }
  
  method dosItemsDeMayorCalidad(){
  	return materiales.sortedBy({unMaterial, otroMaterial =>
  		 unMaterial.calidad() > otroMaterial.calidad()
		}).take(2).sum({material => material.calidad()})   	
  }

}

//-------------------------MATERIALES PARA LOS TEST

object itemDeRecoleccion {
	var materiales = []
	
	method calidad(){
		return 30 + materiales.sum({material=>material.calidad()}) / 10
	}
	
	method agregarMaterial(material){
		materiales.add(material)
	}
}


object unMaterialConCalidadCero {
	var calidad = 0
	
	method calidad(){
		return calidad 
	}
}

object materialMistico {
	var calidad = 500
	
	method esMistico(){
		return true
	}
	
	method calidad(){
		return calidad
	}

}

object unBuenMaterial {
	var calidad = 1000
	
	method calidad(){
		return calidad
	}
}

object material {
	var calidad = 10
	
	method esMistico(){
		return false
	}
	
	method calidad(){
		return calidad
	}
	
}