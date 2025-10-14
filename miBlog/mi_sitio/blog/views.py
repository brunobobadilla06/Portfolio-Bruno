from django.shortcuts import render, get_object_or_404, redirect
from .models import Post
from .forms import PostForm # Lo creo en el paso 8

# Create your views here.
def home(request):
    posts = Post.objects.filter(publicado=True)
    return render(request, 'blog/home.html', {'posts': posts})

def detalle_post(request, slug):
    post = get_object_or_404(Post, slug=slug, publicado=True)
    return render(request, 'blog/detalle.html', {'post': post})

def crear_post(request):
    if request.method == 'POST':
        form = PostForm(request.Post)
        if form.is_valid():
            form.save()
            return redirect('home')
    else:
        form = PostForm()
    return render(request, 'blog/crear.html', {'form': form})