import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

// ======================================================
// APLICAÇÃO
// ======================================================

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lanterna Inteligente',

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppCores.amarelo,
          brightness: Brightness.dark,
        ),

        scaffoldBackgroundColor: AppCores.preto,
      ),

      home: const LanternaScreen(),
    );
  }
}

// ======================================================
// CORES
// ======================================================

class AppCores {
  static const amarelo = Color(0xFFFFD700);
  static const amareloClaro = Color(0xFFFFE766);

  static const preto = Color(0xFF0D0D0D);
  static const cinzaEscuro = Color(0xFF1A1A1A);
  static const cinzaMedio = Color(0xFF2C2C2C);
  static const cinzaClaro = Color(0xFF414141);
  static const cinzaTexto = Color(0xFF888888);

  static const roxo = Color(0xFFAB47BC);
  static const verde = Color(0xFF66BB6A);
  static const vermelho = Color(0xFFEF5350);
}

// ======================================================
// TELA PRINCIPAL
// ======================================================

class LanternaScreen extends StatefulWidget {
  const LanternaScreen({super.key});

  @override
  State<LanternaScreen> createState() => _LanternaScreenState();
}

// ======================================================
// ESTADO
// ======================================================

class _LanternaScreenState extends State<LanternaScreen>
    with SingleTickerProviderStateMixin {
  bool _lanternaLigada = false;
  bool _modoAutomatico = false;

  int _segundosLigada = 0;

  Timer? _timer;

  late AnimationController _animacaoBrilho;

  // ====================================================
  // INICIALIZAÇÃO
  // ====================================================

  @override
  void initState() {
    super.initState();

    _animacaoBrilho = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  // ====================================================
  // FINALIZAÇÃO
  // ====================================================

  @override
  void dispose() {
    _timer?.cancel();
    _animacaoBrilho.dispose();

    super.dispose();
  }

  // ====================================================
  // LIGAR / DESLIGAR
  // ====================================================

  void _alternarLanterna() {
    setState(() {
      _lanternaLigada = !_lanternaLigada;
    });

    if (_lanternaLigada) {
      _iniciarContador();
      _animacaoBrilho.repeat(reverse: true);
    } else {
      _pararContador();

      _animacaoBrilho.stop();
      _animacaoBrilho.reset();
    }
  }

  // ====================================================
  // CONTADOR
  // ====================================================

  void _iniciarContador() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_lanternaLigada && mounted) {
          setState(() {
            _segundosLigada++;
          });
        }
      },
    );
  }

  void _pararContador() {
    _timer?.cancel();

    setState(() {
      _segundosLigada = 0;
    });
  }

  // ====================================================
  // MODO AUTOMÁTICO
  // ====================================================

  void _alternarModoAutomatico(bool valor) {
    setState(() {
      _modoAutomatico = valor;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,

        backgroundColor:
            valor ? AppCores.roxo : AppCores.cinzaMedio,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),

        content: Row(
          children: [
            Icon(
              valor
                  ? Icons.auto_awesome
                  : Icons.auto_mode_outlined,

              color: Colors.white,
            ),

            const SizedBox(width: 10),

            Text(
              valor
                  ? 'Modo Automático ativado'
                  : 'Modo Automático desativado',
            ),
          ],
        ),
      ),
    );
  }

  // ====================================================
  // TEMPO
  // ====================================================

  String _formatarTempo() {
    final minutos = _segundosLigada ~/ 60;
    final segundos = _segundosLigada % 60;

    return '${minutos.toString().padLeft(2, '0')}:'
        '${segundos.toString().padLeft(2, '0')}';
  }

  // ====================================================
  // CABEÇALHO
  // ====================================================

  Widget _cabecalho() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        12,
      ),

      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,

            decoration: BoxDecoration(
              color: AppCores.amarelo.withOpacity(0.12),
              shape: BoxShape.circle,

              border: Border.all(
                color: AppCores.amarelo.withOpacity(0.25),
              ),
            ),

            child: const Icon(
              Icons.flashlight_on,
              color: AppCores.amarelo,
              size: 27,
            ),
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  'Lanterna Inteligente',

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'Controle sua iluminação',

                  style: TextStyle(
                    color: AppCores.cinzaTexto,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          _status(),
        ],
      ),
    );
  }

  // ====================================================
  // STATUS
  // ====================================================

  Widget _status() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),

      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: _lanternaLigada
            ? AppCores.amarelo
            : AppCores.cinzaMedio,

        borderRadius: BorderRadius.circular(30),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Container(
            width: 7,
            height: 7,

            decoration: BoxDecoration(
              color: _lanternaLigada
                  ? Colors.black
                  : AppCores.cinzaTexto,

              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 6),

          Text(
            _lanternaLigada
                ? 'LIGADA'
                : 'DESLIGADA',

            style: TextStyle(
              color: _lanternaLigada
                  ? Colors.black
                  : Colors.white,

              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================
  // MODO AUTOMÁTICO
  // ====================================================

  Widget _modoAutomaticoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),

        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: _modoAutomatico
              ? AppCores.roxo.withOpacity(0.14)
              : AppCores.cinzaEscuro,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: _modoAutomatico
                ? AppCores.roxo
                : AppCores.cinzaMedio,
          ),
        ),

        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),

              width: 46,
              height: 46,

              decoration: BoxDecoration(
                color: _modoAutomatico
                    ? AppCores.roxo
                    : AppCores.cinzaMedio,

                borderRadius:
                    BorderRadius.circular(14),
              ),

              child: Icon(
                _modoAutomatico
                    ? Icons.auto_awesome
                    : Icons.auto_mode_outlined,

                color: Colors.white,
                size: 23,
              ),
            ),

            const SizedBox(width: 13),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    'Modo Automático',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    'Controle inteligente da lanterna',

                    style: TextStyle(
                      color: AppCores.cinzaTexto,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            Switch(
              value: _modoAutomatico,

              activeColor:
                  AppCores.amarelo,

              activeTrackColor:
                  AppCores.amarelo.withOpacity(0.30),

              onChanged:
                  _alternarModoAutomatico,
            ),
          ],
        ),
      ),
    );
  }

  // ====================================================
  // VISUAL DA LANTERNA
  // ====================================================

  Widget _visualLanterna() {
    return AnimatedBuilder(
      animation: _animacaoBrilho,

      builder: (context, child) {
        final valorBrilho =
            _lanternaLigada
                ? 0.30 +
                    (_animacaoBrilho.value * 0.18)
                : 0.0;

        return AnimatedContainer(
          duration:
              const Duration(milliseconds: 500),

          curve: Curves.easeInOut,

          width: _lanternaLigada
              ? 205
              : 140,

          height: _lanternaLigada
              ? 205
              : 140,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: _lanternaLigada
                ? AppCores.amarelo.withOpacity(0.15)
                : AppCores.cinzaEscuro,

            border: Border.all(
              color: _lanternaLigada
                  ? AppCores.amarelo
                  : AppCores.cinzaMedio,

              width: _lanternaLigada
                  ? 2.5
                  : 1.5,
            ),

            boxShadow: _lanternaLigada
                ? [
                    BoxShadow(
                      color: AppCores.amarelo
                          .withOpacity(valorBrilho),

                      blurRadius:
                          40 +
                              (_animacaoBrilho.value *
                                  20),

                      spreadRadius:
                          8 +
                              (_animacaoBrilho.value *
                                  7),
                    ),
                  ]
                : [],
          ),

          child: Center(
            child: AnimatedSwitcher(
              duration:
                  const Duration(milliseconds: 400),

              transitionBuilder:
                  (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },

              child: Icon(
                _lanternaLigada
                    ? Icons.flashlight_on
                    : Icons.flashlight_off,

                key: ValueKey(
                  _lanternaLigada,
                ),

                size: _lanternaLigada
                    ? 88
                    : 64,

                color: _lanternaLigada
                    ? AppCores.amarelo
                    : AppCores.cinzaTexto,
              ),
            ),
          ),
        );
      },
    );
  }

  // ====================================================
  // INFORMAÇÕES
  // ====================================================

  Widget _informacoes() {
    return Column(
      children: [
        AnimatedSwitcher(
          duration:
              const Duration(milliseconds: 300),

          child: Text(
            _lanternaLigada
                ? 'Lanterna ligada'
                : 'Lanterna desligada',

            key: ValueKey(
              _lanternaLigada,
            ),

            style: TextStyle(
              color: _lanternaLigada
                  ? AppCores.amarelo
                  : Colors.white,

              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 7),

        AnimatedSwitcher(
          duration:
              const Duration(milliseconds: 300),

          child: Text(
            _lanternaLigada
                ? 'Iluminação ativada'
                : 'Toque no botão para acender',

            key: ValueKey(
              'descricao$_lanternaLigada',
            ),

            style: const TextStyle(
              color: AppCores.cinzaTexto,
              fontSize: 13,
            ),
          ),
        ),

        if (_lanternaLigada) ...[
          const SizedBox(height: 15),

          _contador(),
        ],
      ],
    );
  }

  // ====================================================
  // CONTADOR
  // ====================================================

  Widget _contador() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: AppCores.cinzaEscuro,

        borderRadius: BorderRadius.circular(30),

        border: Border.all(
          color: AppCores.cinzaMedio,
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          const Icon(
            Icons.timer_outlined,
            color: AppCores.amarelo,
            size: 17,
          ),

          const SizedBox(width: 7),

          Text(
            _formatarTempo(),

            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),

          const SizedBox(width: 5),

          const Text(
            'ligada',

            style: TextStyle(
              color: AppCores.cinzaTexto,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================
  // BOTÃO
  // ====================================================

  Widget _botaoLanterna() {
    return GestureDetector(
      onTap: _alternarLanterna,

      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 350),

        curve: Curves.easeOutBack,

        width: _lanternaLigada
            ? 108
            : 94,

        height: _lanternaLigada
            ? 108
            : 94,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          color: _lanternaLigada
              ? AppCores.amarelo
              : AppCores.cinzaMedio,

          border: Border.all(
            color: _lanternaLigada
                ? AppCores.amareloClaro
                : AppCores.cinzaClaro,

            width: 2,
          ),

          boxShadow: _lanternaLigada
              ? [
                  BoxShadow(
                    color: AppCores.amarelo
                        .withOpacity(0.45),

                    blurRadius: 30,

                    spreadRadius: 5,
                  ),
                ]
              : [],
        ),

        child: Center(
          child: AnimatedSwitcher(
            duration:
                const Duration(milliseconds: 250),

            child: Icon(
              Icons.power_settings_new,

              key: ValueKey(
                _lanternaLigada,
              ),

              size: _lanternaLigada
                  ? 48
                  : 41,

              color: _lanternaLigada
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ====================================================
  // TELA
  // ====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.preto,

      body: SafeArea(
        child: Column(
          children: [
            _cabecalho(),

            const SizedBox(height: 8),

            _modoAutomaticoCard(),

            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    _visualLanterna(),

                    const SizedBox(height: 27),

                    _informacoes(),
                  ],
                ),
              ),
            ),

            _botaoLanterna(),

            const SizedBox(height: 18),

            Text(
              _lanternaLigada
                  ? 'Toque para desligar'
                  : 'Toque para ligar',

              style: const TextStyle(
                color: AppCores.cinzaTexto,
                fontSize: 11,
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
