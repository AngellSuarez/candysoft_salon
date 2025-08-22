import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/search_and_filter_widget.dart';
import './widgets/service_card_widget.dart';
import './widgets/service_creation_bottom_sheet.dart';

class ServiceManagementScreen extends StatefulWidget {
  const ServiceManagementScreen({Key? key}) : super(key: key);

  @override
  State<ServiceManagementScreen> createState() =>
      _ServiceManagementScreenState();
}

class _ServiceManagementScreenState extends State<ServiceManagementScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  // State variables
  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> _filteredServices = [];
  String _searchQuery = '';
  String _selectedCategory = 'Todos';
  bool _isSearchCollapsed = false;
  bool _isLoading = false;
  bool _isRefreshing = false;
  Set<int> _selectedServices = {};
  bool _isMultiSelectMode = false;

  // Categories for filtering
  final List<String> _categories = [
    'Todos',
    'Manicura',
    'Pedicura',
    'Uñas acrílicas',
    'Uñas de gel',
    'Nail art',
    'Tratamientos',
    'Otros'
  ];

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _setupScrollListener();
  }

  void _initializeServices() {
    _services = [
      {
        "id": 1,
        "name": "Manicura Clásica",
        "description":
            "Manicura tradicional con limado, cutícula y esmaltado básico. Perfecta para un look natural y elegante.",
        "category": "Manicura",
        "duration": 45,
        "price": 25.0,
        "image":
            "https://images.pexels.com/photos/3997379/pexels-photo-3997379.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "available": true,
        "createdAt": "2025-08-20T10:00:00Z",
        "updatedAt": "2025-08-22T06:26:18Z"
      },
      {
        "id": 2,
        "name": "Pedicura Spa",
        "description":
            "Tratamiento completo de pies con exfoliación, masaje relajante y esmaltado. Incluye baño de pies aromático.",
        "category": "Pedicura",
        "duration": 75,
        "price": 35.0,
        "image":
            "https://images.pexels.com/photos/3997991/pexels-photo-3997991.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "available": true,
        "createdAt": "2025-08-19T14:30:00Z",
        "updatedAt": "2025-08-22T06:26:18Z"
      },
      {
        "id": 3,
        "name": "Uñas Acrílicas Francesas",
        "description":
            "Extensión de uñas con acrílico y diseño francés clásico. Duración aproximada de 3-4 semanas.",
        "category": "Uñas acrílicas",
        "duration": 120,
        "price": 55.0,
        "image":
            "https://images.pexels.com/photos/3997386/pexels-photo-3997386.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "available": true,
        "createdAt": "2025-08-18T09:15:00Z",
        "updatedAt": "2025-08-22T06:26:18Z"
      },
      {
        "id": 4,
        "name": "Gel Polish",
        "description":
            "Esmaltado semipermanente con gel que dura hasta 3 semanas sin descascararse. Secado con lámpara UV.",
        "category": "Uñas de gel",
        "duration": 60,
        "price": 30.0,
        "image":
            "https://images.pexels.com/photos/3997982/pexels-photo-3997982.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "available": true,
        "createdAt": "2025-08-17T16:45:00Z",
        "updatedAt": "2025-08-22T06:26:18Z"
      },
      {
        "id": 5,
        "name": "Nail Art Personalizado",
        "description":
            "Diseños únicos y creativos en tus uñas. Desde patrones geométricos hasta flores delicadas.",
        "category": "Nail art",
        "duration": 90,
        "price": 45.0,
        "image":
            "https://images.pexels.com/photos/3997983/pexels-photo-3997983.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "available": true,
        "createdAt": "2025-08-16T11:20:00Z",
        "updatedAt": "2025-08-22T06:26:18Z"
      },
      {
        "id": 6,
        "name": "Tratamiento Fortalecedor",
        "description":
            "Tratamiento intensivo para uñas débiles y quebradizas. Incluye vitaminas y proteínas.",
        "category": "Tratamientos",
        "duration": 30,
        "price": 20.0,
        "image":
            "https://images.pexels.com/photos/3997992/pexels-photo-3997992.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "available": false,
        "createdAt": "2025-08-15T13:10:00Z",
        "updatedAt": "2025-08-22T06:26:18Z"
      },
      {
        "id": 7,
        "name": "Manicura Express",
        "description":
            "Servicio rápido de limado y esmaltado para quienes tienen poco tiempo. Sin tratamiento de cutícula.",
        "category": "Manicura",
        "duration": 25,
        "price": 15.0,
        "image":
            "https://images.pexels.com/photos/3997380/pexels-photo-3997380.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "available": true,
        "createdAt": "2025-08-14T08:30:00Z",
        "updatedAt": "2025-08-22T06:26:18Z"
      },
      {
        "id": 8,
        "name": "Pedicura Médica",
        "description":
            "Tratamiento especializado para problemas en los pies como callos, durezas y uñas encarnadas.",
        "category": "Pedicura",
        "duration": 90,
        "price": 50.0,
        "image":
            "https://images.pexels.com/photos/3997993/pexels-photo-3997993.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "available": true,
        "createdAt": "2025-08-13T15:45:00Z",
        "updatedAt": "2025-08-22T06:26:18Z"
      }
    ];
    _filteredServices = List.from(_services);
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      final isCollapsed = _scrollController.offset > 100;
      if (isCollapsed != _isSearchCollapsed) {
        setState(() {
          _isSearchCollapsed = isCollapsed;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          SearchAndFilterWidget(
            searchQuery: _searchQuery,
            selectedCategory: _selectedCategory,
            categories: _categories,
            onSearchChanged: _onSearchChanged,
            onCategoryChanged: _onCategoryChanged,
            isCollapsed: _isSearchCollapsed,
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
      floatingActionButton:
          _isMultiSelectMode ? null : _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        _isMultiSelectMode
            ? '${_selectedServices.length} seleccionados'
            : 'Gestión de Servicios',
      ),
      leading: _isMultiSelectMode
          ? IconButton(
              onPressed: _exitMultiSelectMode,
              icon: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 6.w,
              ),
            )
          : IconButton(
              onPressed: () => Navigator.pop(context),
              icon: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 6.w,
              ),
            ),
      actions: [
        if (_isMultiSelectMode) ...[
          IconButton(
            onPressed:
                _selectedServices.isNotEmpty ? _bulkToggleAvailability : null,
            icon: CustomIconWidget(
              iconName: 'visibility',
              color: _selectedServices.isNotEmpty
                  ? AppTheme.lightTheme.colorScheme.onSurface
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.4),
              size: 6.w,
            ),
          ),
          IconButton(
            onPressed: _selectedServices.isNotEmpty ? _bulkDelete : null,
            icon: CustomIconWidget(
              iconName: 'delete',
              color: _selectedServices.isNotEmpty
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.4),
              size: 6.w,
            ),
          ),
        ] else ...[
          IconButton(
            onPressed: () {
              // Navigate to search screen or expand search
            },
            icon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'refresh',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Text('Actualizar'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'sort',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'sort',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Text('Ordenar'),
                  ],
                ),
              ),
            ],
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_filteredServices.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refreshServices,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _filteredServices.length,
        itemBuilder: (context, index) {
          final service = _filteredServices[index];
          final isSelected = _selectedServices.contains(service['id']);

          return GestureDetector(
            onLongPress: () => _enterMultiSelectMode(service['id'] as int),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primaryContainer
                        .withValues(alpha: 0.2)
                    : null,
              ),
              child: Row(
                children: [
                  if (_isMultiSelectMode) ...[
                    Checkbox(
                      value: isSelected,
                      onChanged: (value) =>
                          _toggleServiceSelection(service['id'] as int),
                    ),
                    SizedBox(width: 2.w),
                  ],
                  Expanded(
                    child: ServiceCardWidget(
                      service: service,
                      onTap: _isMultiSelectMode
                          ? () => _toggleServiceSelection(service['id'] as int)
                          : () => _showServiceDetail(service),
                      onEdit: () => _editService(service),
                      onDuplicate: () => _duplicateService(service),
                      onToggleAvailability: () =>
                          _toggleServiceAvailability(service),
                      onDelete: () => _deleteService(service),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Cargando servicios...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    if (_searchQuery.isNotEmpty || _selectedCategory != 'Todos') {
      return EmptyStateWidget(
        title: 'No se encontraron servicios',
        subtitle:
            'No hay servicios que coincidan con tu búsqueda. Intenta con otros términos o categorías.',
        buttonText: 'Limpiar filtros',
        iconName: 'search_off',
        isSearchResult: true,
        onButtonPressed: _clearFilters,
      );
    }

    return EmptyStateWidget(
      title: '¡Crea tu primer servicio!',
      subtitle:
          'Comienza agregando los servicios que ofreces en tu salón. Tus clientes podrán verlos y reservar citas.',
      buttonText: 'Crear servicio',
      iconName: 'spa',
      onButtonPressed: _createNewService,
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _createNewService,
      icon: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.lightTheme.colorScheme.onSecondary,
        size: 6.w,
      ),
      label: Text(
        'Nuevo servicio',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Event handlers
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterServices();
    });
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
      _filterServices();
    });
  }

  void _filterServices() {
    _filteredServices = _services.where((service) {
      final matchesSearch = _searchQuery.isEmpty ||
          (service['name'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (service['description'] as String? ?? '')
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'Todos' ||
          service['category'] == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCategory = 'Todos';
      _filterServices();
    });
  }

  Future<void> _refreshServices() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Servicios actualizados'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'refresh':
        _refreshServices();
        break;
      case 'sort':
        _showSortOptions();
        break;
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'sort_by_alpha',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Ordenar por nombre'),
              onTap: () {
                Navigator.pop(context);
                _sortServices('name');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'attach_money',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Ordenar por precio'),
              onTap: () {
                Navigator.pop(context);
                _sortServices('price');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Ordenar por duración'),
              onTap: () {
                Navigator.pop(context);
                _sortServices('duration');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _sortServices(String criteria) {
    setState(() {
      switch (criteria) {
        case 'name':
          _filteredServices.sort(
              (a, b) => (a['name'] as String).compareTo(b['name'] as String));
          break;
        case 'price':
          _filteredServices.sort(
              (a, b) => (a['price'] as double).compareTo(b['price'] as double));
          break;
        case 'duration':
          _filteredServices.sort(
              (a, b) => (a['duration'] as int).compareTo(b['duration'] as int));
          break;
      }
    });
  }

  // Service management methods
  void _createNewService() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceCreationBottomSheet(
        onServiceSaved: _addService,
      ),
    );
  }

  void _editService(Map<String, dynamic> service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceCreationBottomSheet(
        existingService: service,
        onServiceSaved: _updateService,
      ),
    );
  }

  void _duplicateService(Map<String, dynamic> service) {
    final duplicatedService = Map<String, dynamic>.from(service);
    duplicatedService['id'] = DateTime.now().millisecondsSinceEpoch;
    duplicatedService['name'] = '${service['name']} (Copia)';
    duplicatedService['createdAt'] = DateTime.now().toIso8601String();
    duplicatedService['updatedAt'] = DateTime.now().toIso8601String();

    _addService(duplicatedService);
  }

  void _addService(Map<String, dynamic> service) {
    setState(() {
      _services.add(service);
      _filterServices();
    });
  }

  void _updateService(Map<String, dynamic> updatedService) {
    setState(() {
      final index =
          _services.indexWhere((s) => s['id'] == updatedService['id']);
      if (index != -1) {
        _services[index] = updatedService;
        _filterServices();
      }
    });
  }

  void _deleteService(Map<String, dynamic> service) {
    setState(() {
      _services.removeWhere((s) => s['id'] == service['id']);
      _filterServices();
    });
  }

  void _toggleServiceAvailability(Map<String, dynamic> service) {
    setState(() {
      service['available'] = !(service['available'] as bool);
      service['updatedAt'] = DateTime.now().toIso8601String();
    });
  }

  void _showServiceDetail(Map<String, dynamic> service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        height: 80.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            if (service['image'] != null)
              Container(
                width: double.infinity,
                height: 25.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomImageWidget(
                    imageUrl: service['image'] as String,
                    width: double.infinity,
                    height: 25.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 3.h),
            Text(
              service['name'] as String,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              service['description'] as String? ?? '',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    'Duración',
                    '${service['duration']} min',
                    'schedule',
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    'Precio',
                    '\$${service['price']}',
                    'attach_money',
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    'Categoría',
                    service['category'] as String,
                    'category',
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    'Estado',
                    service['available'] == true
                        ? 'Disponible'
                        : 'No disponible',
                    service['available'] == true ? 'check_circle' : 'cancel',
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _editService(service);
                    },
                    child: Text('Editar'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cerrar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, String iconName) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  // Multi-select methods
  void _enterMultiSelectMode(int serviceId) {
    setState(() {
      _isMultiSelectMode = true;
      _selectedServices.add(serviceId);
    });
  }

  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedServices.clear();
    });
  }

  void _toggleServiceSelection(int serviceId) {
    setState(() {
      if (_selectedServices.contains(serviceId)) {
        _selectedServices.remove(serviceId);
        if (_selectedServices.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedServices.add(serviceId);
      }
    });
  }

  void _bulkToggleAvailability() {
    setState(() {
      for (final serviceId in _selectedServices) {
        final service = _services.firstWhere((s) => s['id'] == serviceId);
        service['available'] = !(service['available'] as bool);
        service['updatedAt'] = DateTime.now().toIso8601String();
      }
      _exitMultiSelectMode();
    });
  }

  void _bulkDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text(
            '¿Estás seguro de que deseas eliminar ${_selectedServices.length} servicios? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _services.removeWhere(
                    (service) => _selectedServices.contains(service['id']));
                _filterServices();
                _exitMultiSelectMode();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('${_selectedServices.length} servicios eliminados'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
