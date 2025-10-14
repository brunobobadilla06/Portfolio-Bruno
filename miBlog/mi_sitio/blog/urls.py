from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('post/<slug:slug>/', views.detalle_post, name='detalle_post'),
    path('nuevo/', views.crear_post, name = 'crear_post'),
]