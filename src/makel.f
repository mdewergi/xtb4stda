! This file is part of xtb4stda.
!
! Copyright (C) 2015-2019 Stefan Grimme
!
! xtb4stda is free software: you can redistribute it and/or modify it under
! the terms of the GNU Lesser General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! xtb4stda is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU Lesser General Public License for more details.
!
! You should have received a copy of the GNU Lesser General Public License
! along with xtb4stda.  If not, see <https://www.gnu.org/licenses/>.


***********************************************************************
*                                                                     *
*  make the loewdin orthogonalization matrix x = u' s1/2 u            *
*  and the Loewdin orbitals cl from canonical ca
*                                                                     *
***********************************************************************

      subroutine makel(nao, s, can, clo )
      implicit real*8 (a-h,o-z)
      dimension s(nao,nao)
      dimension can(nao,nao)
      dimension clo(nao,nao)
      real*8, allocatable ::aux(:),vecs(:,:),e(:),cc(:,:),x(:,:)

      lwork  = 1 + 6*nao + 2*nao**2
      allocate (vecs(nao,nao),e(nao),aux(lwork),cc(nao,nao))
      allocate (x   (nao,nao))

      vecs = s

      call dsyev ('V','U',nao,vecs,nao,e,aux,lwork,info)

      do i=1,nao
         if(e(i).lt.0) stop 'sorry, must stop in S^1/2!'
         e(i)=dsqrt(e(i))
      enddo

      do m=1,nao
         do i=1,nao
         x (i,m)=     vecs(i,m)
         cc(i,m)=e(m)*vecs(i,m)
         enddo
      enddo

      call dgemm('N','T',nao,nao,nao,1.0d0,x,
     .                   nao,cc,nao,0.0d0,vecs,nao)

      x = vecs
      deallocate(e,aux,cc,vecs)

      moci=nao
      call dgemm('n','n',nao,moci,nao,1.d0,x,nao,can,nao,0.d0,clo,nao)

      deallocate(x)
      return
      end


C unrestricted version
      subroutine umakel(nao, s, cana, canb, cloa, clob )
      implicit real*8 (a-h,o-z)
      dimension s(nao,nao)
      dimension cana(nao,nao)
      dimension cloa(nao,nao)
      dimension canb(nao,nao)
      dimension clob(nao,nao)
      real*8, allocatable ::aux(:),vecs(:,:),e(:),cc(:,:),x(:,:)

      lwork  = 1 + 6*nao + 2*nao**2
      allocate (vecs(nao,nao),e(nao),aux(lwork),cc(nao,nao))
      allocate (x   (nao,nao))

      vecs = s

      call dsyev ('V','U',nao,vecs,nao,e,aux,lwork,info)

      do i=1,nao
         if(e(i).lt.0) stop 'sorry, must stop in S^1/2!'
         e(i)=dsqrt(e(i))
      enddo

      do m=1,nao
         do i=1,nao
         x (i,m)=     vecs(i,m)
         cc(i,m)=e(m)*vecs(i,m)
         enddo
      enddo

      call dgemm('N','T',nao,nao,nao,1.0d0,x,
     .                   nao,cc,nao,0.0d0,vecs,nao)

      x = vecs
      deallocate(e,aux,cc,vecs)

      moci=nao
      call dgemm('n','n',nao,moci,nao,1.d0,x,nao,cana,nao,0.d0,cloa,nao)
      call dgemm('n','n',nao,moci,nao,1.d0,x,nao,canb,nao,0.d0,clob,nao)

      deallocate(x)
      return
      end
