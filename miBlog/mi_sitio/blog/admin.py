from django.contrib import admin
from .models import Post

# Register your models here.
@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    list_display = ('titulo', 'publicado', 'creado')
    list_filter = ('publicado', 'creado')
    search_field = ('titulo', 'contenido')
    prepopulated_fields = {'slug':('titulo',)}