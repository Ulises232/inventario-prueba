$(function () {
    const urlBase = $('#inventario').data('url');
    const $modal = $('#producto-modal');
    const $formulario = $('#producto-formulario');
    const $titulo = $('#producto-modal-titulo');
    const $nombre = $('#producto-nombre');
    const $precio = $('#producto-precio');
    const $estatus = $('#producto-estatus');
    const $activo = $('#producto-activo');
    const $guardar = $('#producto-guardar');

    function enviar(url, datos, $boton, $error) {
        if ($boton.prop('disabled')) return;
        const cabeceras = {};
        cabeceras[$('meta[name="_csrf_header"]').attr('content')] = $('meta[name="_csrf"]').attr('content');
        $error.addClass('d-none').text('');
        $boton.prop('disabled', true);

        $.ajax({url: url, method: 'POST', data: datos, headers: cabeceras})
            .done(function () {
                window.location.reload();
            })
            .fail(function (respuesta) {
                let mensaje = 'No se pudo guardar. Intenta de nuevo.';
                if ([400, 404].includes(respuesta.status) && respuesta.responseText) {
                    mensaje = respuesta.responseText;
                } else if (respuesta.status === 403) {
                    mensaje = 'No tienes permiso o tu sesión expiró. Recarga la página.';
                }
                $error.text(mensaje).removeClass('d-none');
                $boton.prop('disabled', false);
            });
    }

    function mostrarEstatus(activo) {
        $activo.prop('checked', activo);
        $estatus.text(activo ? 'Activo' : 'Inactivo');
    }

    $formulario.on('submit', function (event) {
        event.preventDefault();

        enviar(urlBase + '/guardar', {
            id: $('#producto-id').val(),
            nombre: $nombre.val().trim(),
            precio: $precio.val(),
            activo: $activo.is(':checked')
        }, $guardar, $formulario.find('[data-error]'));
    });

    $modal.on('show.bs.modal', function (event) {
        const $boton = $(event.relatedTarget);
        const editar = $boton.data('modo') === 'editar';

        $titulo.text(editar ? 'Editar producto' : 'Agregar producto');
        $guardar.text(editar ? 'Actualizar' : 'Guardar');
        $('#producto-id').val(editar ? $boton.data('producto-id') : '');
        $nombre.val(editar ? $boton.data('producto-nombre') : '');
        $precio.val(editar ? $boton.data('producto-precio') : '');
        $formulario.find('[data-error]').addClass('d-none').text('');
        mostrarEstatus(editar ? $boton.data('producto-activo') === true : true);
    });

    $modal.on('shown.bs.modal', function () {
        $nombre.trigger('focus');
    });

    $activo.on('change', function () {
        mostrarEstatus($(this).is(':checked'));
    });

    const $modalCantidad = $('[data-modal-cantidad]');
    const $formCantidad = $modalCantidad.find('form');
    const $cantidad = $formCantidad.find('[name="cantidad"]');

    $modalCantidad.on('show.bs.modal', function (event) {
        const $boton = $(event.relatedTarget);
        $formCantidad.trigger('reset').attr('action', $boton.attr('data-url'));
        $formCantidad.find('[data-error]').addClass('d-none').text('');
        $formCantidad.find('[data-nombre]').text($boton.attr('data-producto-nombre'));
        $formCantidad.find('[data-existencias]').text($boton.attr('data-existencias'));
    });

    $modalCantidad.on('shown.bs.modal', function () {
        $cantidad.trigger('focus');
    });

    $formCantidad.on('submit', function (event) {
        event.preventDefault();
        enviar($formCantidad.attr('action'), {cantidad: $cantidad.val()},
            $formCantidad.find('[type="submit"]'), $formCantidad.find('[data-error]'));
    });

    $('[data-cambiar-estatus]').on('click', function () {
        const $boton = $(this);
        enviar(urlBase + '/estado/' + $boton.data('producto-id'), {activo: $boton.data('activo')},
            $boton, $('#inventario-error'));
    });
});
