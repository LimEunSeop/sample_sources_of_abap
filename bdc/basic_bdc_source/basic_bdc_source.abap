*----------------------------------------------------------------------*
* BDC 관련 변수
*----------------------------------------------------------------------*
DATA : gt_bdcdata TYPE TABLE OF bdcdata,
       gs_bdcdata LIKE bdcdata,
       gt_messtab LIKE bdcmsgcoll OCCURS 0 WITH HEADER LINE,
       gs_param   TYPE ctu_params.

*&---------------------------------------------------------------------*
*&      Form  BDC_MAKTX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM bdc_maktx TABLES p_selected STRUCTURE gt_data.

  CLEAR : gs_param.
  gs_param-updmode = 'S'.
  gs_param-dismode = 'N'.

  CLEAR : gt_bdcdata, gt_bdcdata[], gt_messtab, gt_messtab[].
  
  PERFORM dynpro USING : 'X' 'SAPLMGMM'   '0060',
                           ' ' 'BDC_OKCODE'  '=AUSW',
                           ' ' 'RMMG1-MATNR'  p_selected-matnr,

                           'X' 'SAPLMGMM'  '0070',
                           ' ' 'BDC_OKCODE' '=ENTR',
                           ' ' 'MSICHTAUSW-KZSEL(01)'  'X',


                           'X' 'SAPLMGMM' '4004',
                           ' ' 'BDC_OKCODE'  'BU',
                           ' ' 'MAKT-MAKTX'  p_selected-maktx,
                           ' ' 'MARA-SPART'  '10'.

  CALL TRANSACTION 'MM02' USING gt_bdcdata   "위의 설정으로 하고 싶기 때문에 gt_bdcdata로 USING한다.
                          OPTIONS FROM gs_param
                          MESSAGES INTO gt_messtab.


ENDFORM.                    " BDC_MAKTX
*&---------------------------------------------------------------------*
*&      Form  DYNPRO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0328   text
*      -->P_0329   text
*      -->P_0330   text
*----------------------------------------------------------------------*
FORM dynpro USING p_dynbegin p_name p_value.

  IF p_dynbegin EQ 'X'.
    gs_bdcdata-dynbegin = p_dynbegin.
    gs_bdcdata-program  = p_name.
    gs_bdcdata-dynpro   = p_value.
  ELSE.
    gs_bdcdata-fnam = p_name.
    gs_bdcdata-fval = p_value.
  ENDIF.

  APPEND gs_bdcdata TO gt_bdcdata.
  CLEAR  gs_bdcdata.

ENDFORM.