import 'package:flutter/material.dart';
import '../models/event.dart';

class EventFormDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final Event? event; // null si es creación, tiene datos si es edición

  const EventFormDialog({
    super.key,
    required this.onSubmit,
    this.event,
  });

  @override
  State<EventFormDialog> createState() => _EventFormDialogState();
}

class _EventFormDialogState extends State<EventFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;
  late TextEditingController _fechaController;
  late TextEditingController _ubicacionController;
  late TextEditingController _numInvitadosController;
  late String _tipoEventoSeleccionado;

  final List<String> _tipos = [
    'Tecnología',
    'Arte',
    'Deportes',
    'Educación',
    'Negocios',
    'Salud',
    'Fiesta',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _tituloController = TextEditingController(text: widget.event!.titulo);
      _descripcionController =
          TextEditingController(text: widget.event!.descripcion);
      _fechaController = TextEditingController(text: widget.event!.fecha);
      _ubicacionController =
          TextEditingController(text: widget.event!.ubicacion);
      _numInvitadosController =
          TextEditingController(text: widget.event!.numInvitados.toString());
      _tipoEventoSeleccionado = widget.event!.tipoEvento;
    } else {
      _tituloController = TextEditingController();
      _descripcionController = TextEditingController();
      _fechaController = TextEditingController();
      _ubicacionController = TextEditingController();
      _numInvitadosController = TextEditingController();
      _tipoEventoSeleccionado = 'Tecnología';
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _fechaController.dispose();
    _ubicacionController.dispose();
    _numInvitadosController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      _fechaController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final formData = {
      'titulo': _tituloController.text,
      'descripcion': _descripcionController.text,
      'fecha': _fechaController.text,
      'ubicacion': _ubicacionController.text,
      'numInvitados': int.parse(_numInvitadosController.text),
      'tipoEvento': _tipoEventoSeleccionado,
      'estado': 'pendiente',
    };

    widget.onSubmit(formData);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.event != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título del diálogo
                Text(
                  isEditing ? 'Editar Evento' : 'Crear Nuevo Evento',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // Título del evento
                TextFormField(
                  controller: _tituloController,
                  decoration: InputDecoration(
                    labelText: 'Título del Evento',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    prefixIcon: const Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El título es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Descripción
                TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    prefixIcon: const Icon(Icons.description),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción es requerida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Tipo de Evento
                DropdownButtonFormField<String>(
                  value: _tipoEventoSeleccionado,
                  decoration: InputDecoration(
                    labelText: 'Tipo de Evento',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    prefixIcon: const Icon(Icons.category),
                  ),
                  items: _tipos.map((tipo) {
                    return DropdownMenuItem(
                      value: tipo,
                      child: Text(tipo),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _tipoEventoSeleccionado = value!);
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Selecciona un tipo de evento';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Fecha
                TextFormField(
                  controller: _fechaController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    prefixIcon: const Icon(Icons.calendar_today),
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                  ),
                  onTap: _selectDate,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La fecha es requerida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Ubicación
                TextFormField(
                  controller: _ubicacionController,
                  decoration: InputDecoration(
                    labelText: 'Ubicación',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La ubicación es requerida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Número de invitados
                TextFormField(
                  controller: _numInvitadosController,
                  decoration: InputDecoration(
                    labelText: 'Número de Invitados',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    prefixIcon: const Icon(Icons.group),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El número de invitados es requerido';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Ingresa un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                      child: const Text('Cancelar',
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        widget.event != null ? 'Actualizar' : 'Crear',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
