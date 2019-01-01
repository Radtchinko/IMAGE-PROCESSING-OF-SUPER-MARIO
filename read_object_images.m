function [mario,coin,wall,enemy,castle] =read_object_images()
  castle=imread('Castle.png');
  coin=imread('Coin.png');
  enemy=imread('Enemy.png');
  wall=imread('Wall.png');
  mario=imread('Mario.png');
 end