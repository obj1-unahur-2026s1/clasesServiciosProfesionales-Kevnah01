class Universidad {
    const property provincia
    const property honorariosRecomendados
    var donaciones = 0
    method totalDeDonaciones(){
        return donaciones
    }
    method recibirDonacion(unMonto){
        donaciones += unMonto
    }
}
object asociacionDeProfesionalesDelLitoral{
    var donaciones = 0
    method totalDeDonaciones(){
        return donaciones
    }
    method recibirDonacion(unMonto){
        donaciones += unMonto
    }   
}
class ProfesionalVinculado{
    const property universidad
    method honorarios() = universidad.honorariosRecomendados()
    method provinciasHabilitadas() = #{universidad.provincia()}
    method cobrarDinero(unMonto){
        universidad.recibirDonacion(unMonto / 2)
    }
}
class ProfesionalAsociadoAlLitoral{
    const property universidad
    method honorarios() = 3000
    method provinciasHabilitadas() = #{"Entre Rios", "Santa Fe", "Corrientes"}
    method cobrarDinero(unMonto){
        asociacionDeProfesionalesDelLitoral.recibirDonacion(unMonto)
    }
}
class ProfesionalLibre{
    const property universidad
    var property honorarios
    var property provinciasHabilitadas
    var totalRecaudado = 0
    method dineroCobrado(){
        return totalRecaudado
    }
    method cobrarDinero(unMonto){
        totalRecaudado += unMonto
    }
    method pasarDinero(unProfesional, unMonto){
        if (totalRecaudado >= unMonto){
            unProfesional.cobrarDinero(unMonto)
            totalRecaudado -= unMonto
        }
        else{
            self.error("El dinero recaudado no es suficiente para transferir")
        }
    }
}
class EmpresaDeServicios {
    var property honorarioReferencia
    const property profesionales
    const clientes = #{}

    method profesionalesContratadosDe(unaUniversidad){
        return profesionales.filter({p => p.universidad() == unaUniversidad}).size()
    }
    method profesionalesMasCaros(){
        return profesionales.filter({p => p.honorarios() > honorarioReferencia})
    }
    method universidadesFormadorasDeLosProfesionales(){
        return profesionales.map({p => p.universidad()}).asSet()
    }
    method profesionalMasBarato(){
        return profesionales.min({p => p.honorarios()})
    }
    method esDeGenteAcotada(){
        return profesionales.all({p => p.provinciasHabilitadas().size() <= 3})
    }
    //Etapa #2
    method puedeSatisfacer(unSolicitante){
        return profesionales.any({p => unSolicitante.puedeAtendersePor(p)})
    }
    //Etapa #4
    method profesionalesQuePuedenSatisfacer(unSolicitante){
        return profesionales.filter({p => unSolicitante.puedeAtendersePor(p)})
    }
    method darServicio(unSolicitante){
        if (self.puedeSatisfacer(unSolicitante)){
            const profesionalAleatorio = self.profesionalesQuePuedenSatisfacer(unSolicitante).anyOne()
            profesionalAleatorio.cobrarDinero(profesionalAleatorio.honorarios())
            clientes.add(unSolicitante)
        }
        else{
            self.error("No se le puede dar servicio al solicitante")
        }
    }
    method cantidadDeClientes(){
        return clientes.size()
    }
    method tieneComoClienteA(unSolicitante){
        return clientes.contains(unSolicitante)
    }

    // Falta el desafío final "esPocoAtrativo(unProfesional)"
}
class Persona {
    var property provincia
    method puedeAtendersePor(unProfesional){
        return unProfesional.provinciasHabilitadas().contains(provincia)
    }
}
class Institucion{
    var property universidadesReconocidas
    method puedeAtendersePor(unProfesional){
        return universidadesReconocidas.any({u => unProfesional.universidad() == u})
    }
}
class Club{
    var property provincias
    method puedeAtendersePor(unProfesional){
        return unProfesional.provinciasHabilitadas().any({prov => provincias.contains(prov)})
    }
}
