clear all;
close all;
clc;


% string vector containing image names
imageNames = [ 'V:\_4 sist nebulosos\Arquivos do Trabalho Prático 1-20190916\ImagensTeste\ImagensTeste\photo001.jpg';
               'V:\_4 sist nebulosos\Arquivos do Trabalho Prático 1-20190916\ImagensTeste\ImagensTeste\photo002.jpg';
               'V:\_4 sist nebulosos\Arquivos do Trabalho Prático 1-20190916\ImagensTeste\ImagensTeste\photo003.jpg';
               'V:\_4 sist nebulosos\Arquivos do Trabalho Prático 1-20190916\ImagensTeste\ImagensTeste\photo004.jpg';
               'V:\_4 sist nebulosos\Arquivos do Trabalho Prático 1-20190916\ImagensTeste\ImagensTeste\photo005.jpg';
               'V:\_4 sist nebulosos\Arquivos do Trabalho Prático 1-20190916\ImagensTeste\ImagensTeste\photo006.jpg';
               'V:\_4 sist nebulosos\Arquivos do Trabalho Prático 1-20190916\ImagensTeste\ImagensTeste\photo007.jpg';
               'V:\_4 sist nebulosos\Arquivos do Trabalho Prático 1-20190916\ImagensTeste\ImagensTeste\photo008.jpg';
               'V:\_4 sist nebulosos\Arquivos do Trabalho Prático 1-20190916\ImagensTeste\ImagensTeste\photo009.jpg';
               'V:\_4 sist nebulosos\Arquivos do Trabalho Prático 1-20190916\ImagensTeste\ImagensTeste\photo010.jpg';
               'V:\_4 sist nebulosos\Arquivos do Trabalho Prático 1-20190916\ImagensTeste\ImagensTeste\photo011.png';
               ];
 imageNamesCell = cellstr(imageNames);

for arquivo = 1:11

 % obtem a imagem RGB, altera seu tamanho e mostra a imagem original (rows x cols x bands)
 currentImage = strtrim(imageNamesCell{arquivo});
 rgbImage = im2double(imread(currentImage));   % im2double() - converte pixels para double
 rgbImage = imresize(rgbImage,0.25,'box');
 subplot(1,2,1);
 title('Original Image')
 imshow(rgbImage);

 % transforma a imagem (rows x cols x bands) em um array de pixels (rows*cols, bands)
 [rows cols bands] = size(rgbImage);
 arrayImage = zeros(rows*cols, 4);
 k = 1;
 for i = 1: rows;
     for j = 1: cols,
        r = rgbImage(i,j,1);
        g = rgbImage(i,j,2);
        b = rgbImage(i,j,3);
        arrayImage(k,:) = [r,g,b,0];
        k = k+1;
     end
 end

 k = k - 1;
 max = 0;

 for ell = 1:k,
   soma = 0;
   for i = 1: rows,
     for j = 1: cols,
       if rgbImage(i,j,1) == arrayImage(ell,1),
         if rgbImage(i,j,2) == arrayImage(ell,2),
           if rgbImage(i,j,3) == arrayImage(ell,3),
             soma = soma + 1;
           end
         end
       end
     end
   end
   flag = 0;
   for kk = 1:(ell-1)
       if arrayImage(ell,1) == arrayImage(kk,1),
         if arrayImage(ell,2) == arrayImage(kk,2),
           if arrayImage(ell,3) == arrayImage(kk,3),
             flag = 1;
           end
         end
       end
   end

   if flag == 0
     arrayImage(ell, 4) = soma;
   end

   if soma > max
     max = soma;
   end
 end





 % mostra os pixels da imagem no espaço cartesiano R x G x B
% subplot(1,2,2);
% title('Pixels in the RGB space')
% plot3(arrayImage(:,1),arrayImage(:,2),arrayImage(:,3),'b.');
% axis([0 1 0 1 0 1]);
% hold on;
% axis square; grid on;

for ell = 1:k,
  if arrayImage(1,4) > 0
   v = zeros(arrayImage(1,4), 2);
   kk = 1;
    for i = 1: rows,
     for j = 1: cols,
       if rgbImage(i,j,1) == arrayImage(ell,1),
         if rgbImage(i,j,2) == arrayImage(ell,2),
           if rgbImage(i,j,3) == arrayImage(ell,3),
             v(kk, 1) = i;
             v(kk, 2) = j;
             kk = kk + 1;
           end
         end
       end
     end
    end
   result = fun(v, 4, ell+1);
  end
 end
end

