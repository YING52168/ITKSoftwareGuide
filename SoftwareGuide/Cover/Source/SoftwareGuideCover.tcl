#
# This script composes the scene for the Cover of the ITK Software Guide
#
package require vtk
package require vtkinteraction
package require vtktesting

#
#  GrayMatter
#
vtkXMLPolyDataReader grayMatterReader
    grayMatterReader SetFileName "Brain.vtp"

vtkPolyDataMapper grayMatterMapper
    grayMatterMapper SetInputConnection [grayMatterReader GetOutputPort]

vtkActor grayMatterActor
    grayMatterActor SetMapper grayMatterMapper
    eval [grayMatterActor GetProperty] SetColor 0.8  0.6  0.5


#
#  Skull
#
vtkXMLPolyDataReader skullReader
    skullReader SetFileName "Skull2.vtp"

vtkPolyDataMapper skullMapper
    skullMapper SetInputConnection [ skullReader GetOutputPort ]

vtkActor skullActor
    skullActor SetMapper skullMapper
    eval [skullActor GetProperty] SetColor   1.0 1.0 0.9
    skullActor SetScale 1.50 1.50 1.50
    skullActor SetPosition  -105 10 -125


#
#  NeckMuscles
#
vtkXMLPolyDataReader neckMusclesReader
    neckMusclesReader SetFileName "NeckMuscles.vtp"

vtkPolyDataMapper neckMusclesMapper
    neckMusclesMapper SetInputConnection [neckMusclesReader GetOutputPort]

vtkActor neckMusclesActor
    neckMusclesActor SetMapper neckMusclesMapper
    eval [neckMusclesActor GetProperty] SetColor  0.616 0.329 0.267
    neckMusclesActor SetPosition  0 0 -374

#
#  Right Eye
#
vtkXMLPolyDataReader rightEyeReader
    rightEyeReader SetFileName "RightEye.vtp"

vtkPolyDataMapper rightEyeMapper
    rightEyeMapper SetInputConnection [rightEyeReader GetOutputPort]

vtkActor rightEyeActor
    rightEyeActor SetMapper rightEyeMapper
    eval [rightEyeActor GetProperty] SetColor  1.0 1.0 1.0
    rightEyeActor SetPosition  3 0 -149

vtkSphereSource eyeballSource
    eyeballSource SetRadius 14
    eyeballSource SetCenter 65 51 122
    eyeballSource SetThetaResolution 40
    eyeballSource SetPhiResolution 40

vtkPolyDataMapper eyeballMapper
    eyeballMapper SetInputConnection [eyeballSource GetOutputPort]

vtkActor eyeballActor
    eyeballActor SetMapper eyeballMapper
    eval [eyeballActor GetProperty] SetColor   1.0 1.0 1.0
    eval [eyeballActor GetProperty] SetOpacity 0.5
    eyeballActor SetPosition  0 0 -150


vtkSphereSource lensSource
    lensSource SetRadius 3
    lensSource SetCenter 65 37 122
    lensSource SetThetaResolution 40
    lensSource SetPhiResolution 40

vtkPolyDataMapper lensMapper
    lensMapper SetInputConnection [lensSource GetOutputPort]

vtkActor lensActor
    lensActor SetMapper lensMapper
    eval [lensActor GetProperty] SetColor   0.3 0.3 0.3
    lensActor SetScale     1 0.2 1
    lensActor SetPosition  0 -40 -150


#
#  Skin
#
vtkXMLPolyDataReader skinReader
    skinReader SetFileName "SkinClipped.vtp"

vtkPolyDataMapper skinMapper
    skinMapper SetInputConnection [skinReader GetOutputPort]


vtkActor skinActor
    skinActor SetMapper skinMapper
    eval [skinActor GetProperty] SetColor  0.99  0.89  0.79
    skinActor SetPosition  0 0 -200


#
#  Rendering pipeline shared among the anatomical structures
#
vtkRenderer ren1
    ren1 SetBackground  1 1 1

vtkRenderWindow renWin
    renWin AddRenderer ren1
    renWin SetSize 1000 1000

vtkRenderWindowInteractor iren
    iren SetRenderWindow renWin


#
#  Add all the actors
#
ren1 AddActor grayMatterActor
ren1 AddActor skullActor
ren1 AddActor rightEyeActor
ren1 AddActor eyeballActor
#ren1 AddActor lensActor
ren1 AddActor neckMusclesActor
ren1 AddActor skinActor



#
#  Configure camera point of view
#
eval [ren1 GetActiveCamera] SetClippingRange 400 800
eval [ren1 GetActiveCamera] SetFocalPoint    94  114  -60
eval [ren1 GetActiveCamera] SetPosition    -326 -526  127
eval [ren1 GetActiveCamera] ComputeViewPlaneNormal
eval [ren1 GetActiveCamera] SetViewUp   0  0   1
ren1 ResetCamera
eval [ren1 GetActiveCamera] Zoom 1.35


iren AddObserver UserEvent {wm deiconify .vtkInteract}

iren Initialize

renWin Render
ren1   Render

#
#  Saving the rendered image
#  Magnification to 3 will produce a higher resolution image
#
vtkWindowToImageFilter grabber
  grabber SetInput renWin
  grabber SetMagnification 3

vtkPNGWriter writer
  writer SetInputConnection [ grabber GetOutputPort ]
  writer SetFileName "SoftwareGuideCover.png"
#  writer Write

wm withdraw .
#exit
