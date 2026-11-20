package com.inventario.commons;

import com.inventario.entity.Usuario;
import com.inventario.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UsuarioActual {
    private final UsuarioRepository usuarios;

    public Usuario obtenerUsuarioActual() {
        Authentication autenticacion = SecurityContextHolder.getContext().getAuthentication();
        if (autenticacion == null || !autenticacion.isAuthenticated()
                || autenticacion instanceof AnonymousAuthenticationToken) {
            throw new AccessDeniedException("Se requiere una sesión válida.");
        }
        return usuarios.findByCorreo(autenticacion.getName())
                .orElseThrow(() -> new AccessDeniedException("El usuario de la sesión no existe."));
    }
}
