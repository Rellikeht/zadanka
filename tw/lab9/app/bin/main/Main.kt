import kotlinx.coroutines.*
import kotlinx.coroutines.channels.*
import kotlinx.coroutines.selects.*

fun zad1(N: Int) = runBlocking {
    var ins = arrayOf<Channel<Boolean>>()
    var out = Channel<Boolean>()

    println("Zadanie 1")

    // middlemen
    for (i in 0 ..< N) {
        ins += Channel<Boolean>()
        launch {
            while (true) {
                out.send(ins[i].receive())
                println("Pośrednik " + i + " aktywowany")
            }
        }
    }

    // consumer
    launch {
        while (true) {
            out.receive()
            delay((10L..100L).random())
        }
    }

    // producer
    launch {
        while (true) {
            selectUnbiased<Unit> {
                for (i in 0 ..< N) {
                    ins[i].onSend(true) {}
                }
            }
            delay((5L..20L).random())
        }
    }
}

fun zad2(N: Int) = runBlocking {
    var transmission = arrayOf<Channel<Boolean>>()
    transmission += Channel<Boolean>()
    println("Zadanie 2")

    // producer
    launch {
        while (true) {
            delay((10L..100L).random())
            println("produkcja")
            transmission[0].send(true)
        }
    }

    for (i in 0 ..< (N)) {
        transmission += Channel<Boolean>()
        launch {
            while (true) {
                val value = transmission[i].receive()
                println("przetwarzanie " + i)
                delay((10L..100L).random())
                transmission[i + 1].send(value)
            }
        }
    }

    // consumer
    launch {
        while (true) {
            println("konsumpcja")
            transmission[N].receive()
            delay((10L..100L).random())
        }
    }
}

fun main(args: Array<String>) {
    val N = 20
    if (args.isNotEmpty() && args[0] == "2") {
        zad2(N)
    } else {
        zad1(N)
    }
}
