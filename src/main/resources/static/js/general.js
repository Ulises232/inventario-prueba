$(function () {
    const pesos = new Intl.NumberFormat('es-MX', {style: 'currency', currency: 'MXN'});
    $('[data-precio]').each(function () {
        $(this).text(pesos.format(Number($(this).attr('data-precio'))));
    });

    const normalizarRuta = (ruta) => ruta.replace(/\/+$/, '') || '/';
    const rutaActual = normalizarRuta(window.location.pathname);
    let enlaceActivo = null;

    $('.app-sidebar .nav-link').each(function () {
        const $enlace = $(this);
        const rutaEnlace = normalizarRuta(this.pathname);
        const rutaAlternativa = $enlace.attr('data-ruta-alternativa');

        $enlace.removeClass('active').removeAttr('aria-current');
        $enlace.closest('.nav-item').removeClass('active');

        const coincide = rutaActual === rutaEnlace
            || rutaActual.startsWith(rutaEnlace + '/')
            || (rutaAlternativa && rutaActual === normalizarRuta(rutaAlternativa));

        if (coincide && (!enlaceActivo || rutaEnlace.length > normalizarRuta(enlaceActivo.pathname).length)) {
            enlaceActivo = this;
        }
    });

    $(enlaceActivo).addClass('active').attr('aria-current', 'page')
        .closest('.nav-item').addClass('active');
});
